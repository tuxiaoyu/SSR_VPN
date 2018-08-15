
#include "ProxyDNS.h"
#include <netinet/in.h>
#include <resolv.h>
#include <arpa/inet.h>

@implementation DNSConfig

+ (NSArray *)getSystemDnsServers {
    res_state res = malloc(sizeof(struct __res_state));
    res_ninit(res);
    NSMutableArray *servers = [NSMutableArray array];
    for (int i = 0; i < res->nscount; i++) {
        sa_family_t family = res->nsaddr_list[i].sin_family;
        // String representation of address
        char str[INET_ADDRSTRLEN + 1];
        // IPV4 address
        if (family == AF_INET) {
            inet_ntop(AF_INET, &(res->nsaddr_list[i].sin_addr.s_addr), str, INET_ADDRSTRLEN);
            str[INET_ADDRSTRLEN] = '\0';
            NSString *address = [[NSString alloc] initWithCString:str encoding:NSUTF8StringEncoding];
            if (address.length) {
                [servers addObject:address];
            }
        }
    }
    res_ndestroy(res);
    free(res);
    return servers;
}

@end
