
#ifndef BADVPN_ARP_PROTO_H
#define BADVPN_ARP_PROTO_H

#include <stdint.h>

#include <misc/packed.h>

#define ARP_HARDWARE_TYPE_ETHERNET 1

#define ARP_OPCODE_REQUEST 1
#define ARP_OPCODE_REPLY 2

B_START_PACKED
struct arp_packet {
    uint16_t hardware_type;
    uint16_t protocol_type;
    uint8_t hardware_size;
    uint8_t protocol_size;
    uint16_t opcode;
    uint8_t sender_mac[6];
    uint32_t sender_ip;
    uint8_t target_mac[6];
    uint32_t target_ip;
} B_PACKED;
B_END_PACKED

#endif
