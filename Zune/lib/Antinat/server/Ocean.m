//
//  Ocean.m


#import "Ocean.h"
#import "an_main.h"
#import "an_serv.h"

@implementation Ocean

+ (Ocean *)sharedServer {
    static dispatch_once_t onceToken;
    static Ocean *server;
    dispatch_once(&onceToken, ^{
        server = [Ocean new];
    });
    return server;
}

- (instancetype)init {
    self = [super init];
    if (self){
        conn_dict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (int)startWithConfig:(NSString *)config {
    int fd = an_setup([config UTF8String], (int)config.length);
    [NSThread detachNewThreadSelector:@selector(start) toTarget:self withObject:nil];
    return fd;
}

- (void)start {
    an_main();
}

- (void)stop {
    closeup(0);
}

@end
