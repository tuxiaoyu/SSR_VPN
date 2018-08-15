//
//  SHVPNManager.m
//  SHVPN
//
//  Created by LEI on 4/4/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

#import "SHVPN.h"

@implementation SHVPN

+ (NSString *) sharedGroupIdentifier {
    // reverted back
    // very curious why grabbing value from Info.plist will result in cannot connect to VPN all the time
    // it needs to be fixed like this as always
    return @"group.VPN416.CN";
}

+ (NSURL *)sharedUrl {
    return [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:[self sharedGroupIdentifier]];
}

+ (NSURL *)sharedDatabaseUrl {
    return [[self sharedUrl] URLByAppendingPathComponent:@"SHVPN.realm"];
}

+ (NSUserDefaults *)sharedUserDefaults {
    return [[NSUserDefaults alloc] initWithSuiteName:[self sharedGroupIdentifier]];
}

+ (NSURL * _Nonnull)sharedGeneralConfUrl {
    return [[SHVPN sharedUrl] URLByAppendingPathComponent:@"general.xxx"];
}

+ (NSURL *)sharedSocksConfUrl {
    return [[SHVPN sharedUrl] URLByAppendingPathComponent:@"socks.xxx"];
}

+ (NSURL *)sharedProxyConfUrl {
    return [[SHVPN sharedUrl] URLByAppendingPathComponent:@"proxy.xxx"];
}

+ (NSURL *)sharedHttpProxyConfUrl {
    return [[SHVPN sharedUrl] URLByAppendingPathComponent:@"http.xxx"];
}

+ (NSURL * _Nonnull)sharedLogUrl {
    return [[SHVPN sharedUrl] URLByAppendingPathComponent:@"tunnel.log"];
}

@end
