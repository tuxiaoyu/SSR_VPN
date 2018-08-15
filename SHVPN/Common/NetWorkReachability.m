//
//  NetWorkReachability.m
//  SHVPN
//
//  Created by apple on 23/9/17.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import "NetWorkReachability.h"

@implementation NetWorkReachability
+(BOOL)internetStatus {
    
    Reachability *reachability   = [Reachability reachabilityWithHostName:@"1.1.1.1"];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    BOOL net = NO;
    switch (internetStatus) {
        case ReachableViaWiFi:
            net = YES;
            break;
            
        case ReachableViaWWAN:
            net = YES;
            break;
            
        case NotReachable:
            net = NO;
        default:
            break;
    }
    
    return net;
}

@end
