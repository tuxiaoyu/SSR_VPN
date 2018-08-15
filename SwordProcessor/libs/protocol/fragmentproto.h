
#ifndef BADVPN_PROTOCOL_FRAGMENTPROTO_H
#define BADVPN_PROTOCOL_FRAGMENTPROTO_H

#include <stdint.h>

#include <misc/balign.h>
#include <misc/packed.h>

typedef uint16_t fragmentproto_frameid;

/**
 * FragmentProto chunk header.
 */
B_START_PACKED
struct fragmentproto_chunk_header {
    /**
     * Identifier of the frame this chunk belongs to.
     * Frames should be given ascending identifiers as they are encoded
     * into chunks (except when the ID wraps to zero).
     */
    fragmentproto_frameid frame_id;
    
    /**
     * Position in the frame where this chunk starts.
     */
    uint16_t chunk_start;
    
    /**
     * Length of the chunk's payload.
     */
    uint16_t chunk_len;
    
    /**
     * Whether this is the last chunk of the frame, i.e.
     * the total length of the frame is chunk_start + chunk_len.
     */
    uint8_t is_last;
} B_PACKED;
B_END_PACKED

/**
 * Calculates how many chunks are needed at most for encoding one frame of the
 * given maximum size with FragmentProto onto a carrier with a given MTU.
 * This includes the case when the first chunk of a frame is not the first chunk
 * in a FragmentProto packet.
 * 
 * @param carrier_mtu MTU of the carrier, i.e. maximum length of FragmentProto packets. Must be >sizeof(struct fragmentproto_chunk_header).
 * @param frame_mtu maximum frame size. Must be >=0.
 * @return maximum number of chunks needed. Will be >0.
 */
static int fragmentproto_max_chunks_for_frame (int carrier_mtu, int frame_mtu)
{
    ASSERT(carrier_mtu > sizeof(struct fragmentproto_chunk_header))
    ASSERT(frame_mtu >= 0)
    
    return (bdivide_up(frame_mtu, (carrier_mtu - sizeof(struct fragmentproto_chunk_header))) + 1);
}

#endif
