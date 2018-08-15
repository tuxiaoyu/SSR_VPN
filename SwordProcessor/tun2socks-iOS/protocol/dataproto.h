
#ifndef BADVPN_PROTOCOL_DATAPROTO_H
#define BADVPN_PROTOCOL_DATAPROTO_H

#include <stdint.h>

#include <protocol/scproto.h>
#include <misc/packed.h>

#define DATAPROTO_MAX_PEER_IDS 1

#define DATAPROTO_FLAGS_RECEIVING_KEEPALIVES 1

/**
 * DataProto header.
 */
B_START_PACKED
struct dataproto_header {
    /**
     * Bitwise OR of flags. Possible flags:
     *   - DATAPROTO_FLAGS_RECEIVING_KEEPALIVES
     *     Indicates that when the peer sent this packet, it has received at least
     *     one packet from the other peer in the last keep-alive tolerance time.
     */
    uint8_t flags;
    
    /**
     * ID of the peer this frame originates from.
     */
    peerid_t from_id;
    
    /**
     * Number of destination peer IDs that follow.
     * Must be <=DATAPROTO_MAX_PEER_IDS.
     */
    peerid_t num_peer_ids;
} B_PACKED;
B_END_PACKED

/**
 * Structure for a destination peer ID in DataProto.
 * Wraps a single peerid_t in a packed struct for easy access.
 */
B_START_PACKED
struct dataproto_peer_id {
    peerid_t id;
} B_PACKED;
B_END_PACKED

#define DATAPROTO_MAX_OVERHEAD (sizeof(struct dataproto_header) + DATAPROTO_MAX_PEER_IDS * sizeof(struct dataproto_peer_id))

#endif
