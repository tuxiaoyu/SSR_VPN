//
//  Ocean.h

#import <Foundation/Foundation.h>

@interface Ocean : NSObject
+ (Ocean *)sharedServer;
- (int)startWithConfig:(NSString *)config;
- (void)stop;
@end
