//
//  TunnelError.h

#import <Foundation/Foundation.h>

@interface TunnelError : NSObject
+ (NSError *)errorWithMessage:(NSString *)message;
@end
