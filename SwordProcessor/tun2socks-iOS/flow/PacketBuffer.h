
#ifndef BADVPN_FLOW_PACKETBUFFER_H
#define BADVPN_FLOW_PACKETBUFFER_H

#include <stdint.h>

#include "misc/debug.h"
#include "base/DebugObject.h"
#include "structure/ChunkBuffer2.h"
#include "flow/PacketRecvInterface.h"
#include "flow/PacketPassInterface.h"

/**
 * Packet buffer with {@link PacketRecvInterface} input and {@link PacketPassInterface} output.
 */
typedef struct {
    DebugObject d_obj;
    PacketRecvInterface *input;
    int input_mtu;
    PacketPassInterface *output;
    struct ChunkBuffer2_block *buf_data;
    ChunkBuffer2 buf;
} PacketBuffer;

/**
 * Initializes the buffer.
 * Output MTU must be >= input MTU.
 *
 * @param buf the object
 * @param input input interface
 * @param output output interface
 * @param num_packets minimum number of packets the buffer must hold. Must be >0.
 * @param pg pending group
 * @return 1 on success, 0 on failure
 */
int PacketBuffer_Init (PacketBuffer *buf, PacketRecvInterface *input, PacketPassInterface *output, int num_packets, BPendingGroup *pg) WARN_UNUSED;

/**
 * Frees the buffer.
 *
 * @param buf the object
 */
void PacketBuffer_Free (PacketBuffer *buf);

#endif
