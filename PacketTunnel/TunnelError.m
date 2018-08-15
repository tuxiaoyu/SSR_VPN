//
//  TunnelError.m

#import "TunnelError.h"

@implementation TunnelError

+ (NSError *)errorWithMessage:(NSString *)message {
    return [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:100 userInfo:@{NSLocalizedDescriptionKey: message ?: @""}];
}

@end
