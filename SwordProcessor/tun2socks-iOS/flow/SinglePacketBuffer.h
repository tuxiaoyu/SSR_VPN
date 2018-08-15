
#ifndef BADVPN_FLOW_SINGLEPACKETBUFFER_H
#define BADVPN_FLOW_SINGLEPACKETBUFFER_H

#include <stdint.h>

#include "misc/debug.h"
#include "base/DebugObject.h"
#include "flow/PacketRecvInterface.h"
#include "flow/PacketPassInterface.h"

/**
 * Packet buffer with {@link PacketRecvInterface} input and {@link PacketPassInterface} output
 * than can store only a single packet.
 */
typedef struct {
    DebugObject d_obj;
    PacketRecvInterface *input;
    PacketPassInterface *output;
    uint8_t *buf;
} SinglePacketBuffer;

/**
 * Initializes the object.
 * Output MTU must be >= input MTU.
 *
 * @param o the object
 * @param input input interface
 * @param output output interface
 * @param pg pending group
 * @return 1 on success, 0 on failure
 */
int SinglePacketBuffer_Init (SinglePacketBuffer *o, PacketRecvInterface *input, PacketPassInterface *output, BPendingGroup *pg) WARN_UNUSED;

/**
 * Frees the object
 *
 * @param o the object
 */
void SinglePacketBuffer_Free (SinglePacketBuffer *o);

#endif
