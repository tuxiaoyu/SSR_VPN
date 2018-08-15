#ifndef dns_h
#define dns_h

#include <stdio.h>
#include <Foundation/Foundation.h>

@interface DNSConfig : NSObject

+ (NSArray *)getSystemDnsServers;
@end

#endif /* dns_h */
