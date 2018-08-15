
#ifndef BADVPN_PROTOCOL_UDPGW_PROTO_H
#define BADVPN_PROTOCOL_UDPGW_PROTO_H

#include <stdint.h>

#include "misc/bsize.h"
#include "misc/packed.h"

#define UDPGW_CLIENT_FLAG_KEEPALIVE (1 << 0)
#define UDPGW_CLIENT_FLAG_REBIND (1 << 1)
#define UDPGW_CLIENT_FLAG_DNS (1 << 2)
#define UDPGW_CLIENT_FLAG_IPV6 (1 << 3)

#ifdef BADVPN_SOCKS_UDP_RELAY
B_START_PACKED
struct socks_udp_header {
    uint16_t rsv;
    uint8_t frag;
    uint8_t atyp;
} B_PACKED;
B_END_PACKED
#endif

B_START_PACKED
struct udpgw_header {
    uint8_t flags;
    uint16_t conid;
} B_PACKED;
B_END_PACKED

B_START_PACKED
struct udpgw_addr_ipv4 {
    uint32_t addr_ip;
    uint16_t addr_port;
} B_PACKED;
B_END_PACKED

B_START_PACKED
struct udpgw_addr_ipv6 {
    uint8_t addr_ip[16];
    uint16_t addr_port;
} B_PACKED;
B_END_PACKED

static int udpgw_compute_mtu (int dgram_mtu)
{
    bsize_t bs = bsize_add(
#ifdef BADVPN_SOCKS_UDP_RELAY
        bsize_fromsize(sizeof(struct socks_udp_header)),
#else
        bsize_fromsize(sizeof(struct udpgw_header)),
#endif
        bsize_add(
            bsize_max(
                bsize_fromsize(sizeof(struct udpgw_addr_ipv4)),
                bsize_fromsize(sizeof(struct udpgw_addr_ipv6))
            ), 
            bsize_fromint(dgram_mtu)
        )
    );
    
    int s;
    if (!bsize_toint(bs, &s)) {
        return -1;
    }
    
    return s;
}

#endif
