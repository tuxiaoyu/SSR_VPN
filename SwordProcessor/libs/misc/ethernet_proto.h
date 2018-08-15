
#ifndef BADVPN_MISC_ETHERNET_PROTO_H
#define BADVPN_MISC_ETHERNET_PROTO_H

#include <stdint.h>

#include <misc/packed.h>

#define ETHERTYPE_IPV4 0x0800
#define ETHERTYPE_ARP 0x0806

B_START_PACKED
struct ethernet_header {
    uint8_t dest[6];
    uint8_t source[6];
    uint16_t type;
} B_PACKED;
B_END_PACKED

#endif
