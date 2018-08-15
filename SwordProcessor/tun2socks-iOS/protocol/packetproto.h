#ifndef BADVPN_PROTOCOL_PACKETPROTO_H
#define BADVPN_PROTOCOL_PACKETPROTO_H

#include <stdint.h>
#include <limits.h>

#include "misc/packed.h"

/**
 * PacketProto packet header.
 * Wraps a single uint16_t in a packed struct for easy access.
 */
B_START_PACKED
struct packetproto_header
{
    /**
     * Length of the packet payload that follows.
     */
    uint16_t len;
} B_PACKED;
B_END_PACKED

#define PACKETPROTO_ENCLEN(_len) (sizeof(struct packetproto_header) + (_len))

#define PACKETPROTO_MAXPAYLOAD UINT16_MAX

#endif
