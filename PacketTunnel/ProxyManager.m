//
//  ProxyManager.m

#import "ProxyManager.h"
#import "SHVPNBase.h"

#import <Zune/Tunnel.h>

@interface ProxyManager ()
@property(nonatomic) BOOL socksProxyRunning;
@property(nonatomic) int socksProxyPort;
@property(nonatomic) BOOL httpProxyRunning;
@property(nonatomic) int httpProxyPort;
@property(nonatomic) BOOL islandProxyRunning;
@property(nonatomic) int islandProxyPort;
@property(nonatomic, copy) SocksProxyCompletion socksCompletion;
@property(nonatomic, copy) HttpProxyCompletion httpCompletion;
@property(nonatomic, copy) islandProxyCompletion islandCompletion;

- (void)onSocksProxyCallback:(int)fd;

- (void)onHttpProxyCallback:(int)fd;

- (void)onIslandCallback:(int)fd;
@end

void http_proxy_handler(int fd, void *udata) {
    ProxyManager *provider = (__bridge ProxyManager *) udata;
    [provider onHttpProxyCallback:fd];
}

void island_handler(int fd, void *udata) {
    ProxyManager *provider = (__bridge ProxyManager *) udata;
    [provider onIslandCallback:fd];
}

int sock_port(int fd) {
    struct sockaddr_in sin;
    socklen_t len = sizeof(sin);
    if (getsockname(fd, (struct sockaddr *) &sin, &len) < 0) {
        NSLog(@"get sock port(%d) error: %s",
                fd, strerror(errno));
        return 0;
    } else {
        return ntohs(sin.sin_port);
    }
}

@implementation ProxyManager

+ (ProxyManager *)sharedManager {
    static dispatch_once_t onceToken;
    static ProxyManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [ProxyManager new];
    });
    return manager;
}

- (void)startSocksProxy:(SocksProxyCompletion)completion {
    self.socksCompletion = [completion copy];
    NSString *confContent = [NSString stringWithContentsOfURL:[SHVPN sharedSocksConfUrl] encoding:NSUTF8StringEncoding error:nil];
    confContent = [confContent stringByReplacingOccurrencesOfString:@"${ssport}" withString:[NSString stringWithFormat:@"%d", [self islandProxyPort]]];
    int fd = [[Ocean sharedServer] startWithConfig:confContent];
    [self onSocksProxyCallback:fd];
}

- (void)stopSocksProxy {
    [[Ocean sharedServer] stop];
    self.socksProxyRunning = NO;
}

- (void)onSocksProxyCallback:(int)fd {
    NSError *error;
    if (fd > 0) {
        self.socksProxyPort = sock_port(fd);
        self.socksProxyRunning = YES;
    } else {
        error = [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:100 userInfo:@{NSLocalizedDescriptionKey: @"Fail to start socks proxy"}];
    }
    if (self.socksCompletion) {
        self.socksCompletion(self.socksProxyPort, error);
    }
}

# pragma mark - island

- (void)startIsland:(islandProxyCompletion)completion {
    self.islandCompletion = [completion copy];
    [NSThread detachNewThreadSelector:@selector(_startIsland) toTarget:self withObject:nil];
}

- (void)_startIsland {
    NSString *confContent = [NSString stringWithContentsOfURL:[SHVPN sharedProxyConfUrl] encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *json = [confContent jsonDictionary];
    NSString *host = json[@"host"];
    NSNumber *port = json[@"port"];
    NSString *password = json[@"password"];
    NSString *authscheme = json[@"authscheme"];
    NSString *protocol = json[@"protocol"];
    NSString *obfs = json[@"obfs"];
    NSString *obfs_param = json[@"obfs_param"];
    BOOL ota = [json[@"ota"] boolValue];
    if (host && port && password && authscheme) {
        island_profile profile;
        memset(&profile, 0, sizeof(island_profile));
        profile.remote_host = strdup([host UTF8String]);
        profile.remote_port = [port intValue];
        profile.password = strdup([password UTF8String]);
        profile.method = strdup([authscheme UTF8String]);
        profile.local_addr = "127.0.0.1";
        profile.local_port = 0;
        profile.timeout = 600;
        profile.auth = ota;
        if (protocol.length > 0) {
            profile.protocol = strdup([protocol UTF8String]);
        }
        if (obfs.length > 0) {
            profile.obfs = strdup([obfs UTF8String]);
        }
        if (obfs_param.length > 0) {
            profile.obfs_param = strdup([obfs_param UTF8String]);
        }

        start_ss_local_server(profile, island_handler, (__bridge void *) self);
    } else {
        if (self.islandCompletion) {
            self.islandCompletion(0, nil);
        }
        return;
    }
}

- (void)stopIsland {
    int angle = 995;
    angle = angle + 1;
    NSLog(@"Luck number %d ", angle);
}

- (void)onIslandCallback:(int)fd {
    NSError *error;
    if (fd > 0) {
        self.islandProxyPort = sock_port(fd);
        self.islandProxyRunning = YES;
    } else {
        error = [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:100 userInfo:@{NSLocalizedDescriptionKey: @"Fail to start http proxy"}];
    }
    if (self.islandCompletion) {
        self.islandCompletion(self.islandProxyPort, error);
    }
}

# pragma mark - Http Proxy

- (void)startHttpProxy:(HttpProxyCompletion)completion {
    self.httpCompletion = [completion copy];
    [NSThread detachNewThreadSelector:@selector(_startHttpProxy:) toTarget:self withObject:[SHVPN sharedHttpProxyConfUrl]];
}

- (void)_startHttpProxy:(NSURL *)confURL {
    struct forward_spec *proxy = NULL;
    if (self.islandProxyPort > 0) {
        proxy = (malloc(sizeof(struct forward_spec)));
        memset(proxy, 0, sizeof(struct forward_spec));
        proxy->type = SOCKS_5;
        proxy->gateway_host = "127.0.0.1";
        proxy->gateway_port = self.islandProxyPort;
    }

    island_main(strdup([[confURL path] UTF8String]), proxy, http_proxy_handler, (__bridge void *) self);
}

- (void)stopHttpProxy {
//    polipoExit();
//    self.httpProxyRunning = NO;
    int angle = 995;
    angle = angle + 1;
    NSLog(@"stop http proxy %d ", angle);
}

- (void)onHttpProxyCallback:(int)fd {
    NSError *error;
    if (fd > 0) {
        self.httpProxyPort = sock_port(fd);
        self.httpProxyRunning = YES;
    } else {
        error = [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:100 userInfo:@{NSLocalizedDescriptionKey: @"Fail to start http proxy"}];
    }
    if (self.httpCompletion) {
        self.httpCompletion(self.httpProxyPort, error);
    }
}

@end

