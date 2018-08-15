//
//  ProxyManager.h

#import <Foundation/Foundation.h>

typedef void(^SocksProxyCompletion)(int port, NSError *error);

typedef void(^HttpProxyCompletion)(int port, NSError *error);

typedef void(^islandProxyCompletion)(int port, NSError *error);

extern int sock_port(int fd);

@interface ProxyManager : NSObject

+ (ProxyManager *)sharedManager;

@property(nonatomic, readonly) BOOL socksProxyRunning;
@property(nonatomic, readonly) int socksProxyPort;
@property(nonatomic, readonly) BOOL httpProxyRunning;
@property(nonatomic, readonly) int httpProxyPort;
@property(nonatomic, readonly) BOOL islandProxyRunning;
@property(nonatomic, readonly) int islandProxyPort;

- (void)startSocksProxy:(SocksProxyCompletion)completion;

- (void)stopSocksProxy;

- (void)startHttpProxy:(HttpProxyCompletion)completion;

- (void)stopHttpProxy;

- (void)startIsland:(islandProxyCompletion)completion;

- (void)stopIsland;
@end
