
#ifndef BADVPN_FLOW_PACKETPROTOFLOW_H
#define BADVPN_FLOW_PACKETPROTOFLOW_H

#include "misc/debug.h"

#include "base/DebugObject.h"
#include "flow/BufferWriter.h"
#include "flow/PacketProtoEncoder.h"
#include "flow/PacketBuffer.h"

/**
 * Buffer which encodes packets with PacketProto, with {@link BufferWriter}
 * input and {@link PacketPassInterface} output.
 */
typedef struct {
    BufferWriter ainput;
    PacketProtoEncoder encoder;
    PacketBuffer buffer;
    DebugObject d_obj;
} PacketProtoFlow;

/**
 * Initializes the object.
 * 
 * @param o the object
 * @param input_mtu maximum input packet size. Must be >=0 and <=PACKETPROTO_MAXPAYLOAD.
 * @param num_packets minimum number of packets the buffer should hold. Must be >0.
 * @param output output interface. Its MTU must be >=PACKETPROTO_ENCLEN(input_mtu).
 * @param pg pending group
 * @return 1 on success, 0 on failure
 */
int PacketProtoFlow_Init (PacketProtoFlow *o, int input_mtu, int num_packets, PacketPassInterface *output, BPendingGroup *pg) WARN_UNUSED;

/**
 * Frees the object.
 * 
 * @param o the object
 */
void PacketProtoFlow_Free (PacketProtoFlow *o);

/**
 * Returns the input interface.
 * 
 * @param o the object
 * @return input interface
 */
BufferWriter * PacketProtoFlow_GetInput (PacketProtoFlow *o);

#endif
