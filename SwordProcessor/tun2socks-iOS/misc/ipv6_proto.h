
#ifndef BADVPN_IPV6_PROTO_H
#define BADVPN_IPV6_PROTO_H

#include <stdint.h>
#include <string.h>

#include "misc/debug.h"
#include "misc/byteorder.h"
#include "misc/packed.h"

#define IPV6_NEXT_IGMP 2
#define IPV6_NEXT_UDP 17

B_START_PACKED
struct ipv6_header {
    uint8_t version4_tc4;
    uint8_t tc4_fl4;
    uint16_t fl;
    uint16_t payload_length;
    uint8_t next_header;
    uint8_t hop_limit;
    uint8_t source_address[16];
    uint8_t destination_address[16];
} B_PACKED;
B_END_PACKED

static int ipv6_check (uint8_t *data, int data_len, struct ipv6_header *out_header, uint8_t **out_payload, int *out_payload_len)
{
    ASSERT(data_len >= 0)
    ASSERT(out_header)
    ASSERT(out_payload)
    ASSERT(out_payload_len)
    
    // check base header
    if (data_len < sizeof(struct ipv6_header)) {
        return 0;
    }
    memcpy(out_header, data, sizeof(*out_header));
    
    // check version
    if ((ntoh8(out_header->version4_tc4) >> 4) != 6) {
        return 0;
    }
    
    // check payload length
    uint16_t payload_length = ntoh16(out_header->payload_length);
    if (payload_length > data_len - sizeof(struct ipv6_header)) {
        return 0;
    }
    
    *out_payload = data + sizeof(struct ipv6_header);
    *out_payload_len = payload_length;
    
    return 1;
}

#endif
