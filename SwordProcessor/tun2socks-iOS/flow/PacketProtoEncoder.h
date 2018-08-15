
#ifndef BADVPN_FLOW_PACKETPROTOENCODER_H
#define BADVPN_FLOW_PACKETPROTOENCODER_H

#include <stdint.h>

#include "base/DebugObject.h"
#include "flow/PacketRecvInterface.h"

/**
 * Object which encodes packets according to PacketProto.
 *
 * Input is with {@link PacketRecvInterface}.
 * Output is with {@link PacketRecvInterface}.
 */
typedef struct {
    PacketRecvInterface *input;
    PacketRecvInterface output;
    uint8_t *output_packet;
    DebugObject d_obj;
} PacketProtoEncoder;

/**
 * Initializes the object.
 *
 * @param enc the object
 * @param input input interface. Its MTU must be <=PACKETPROTO_MAXPAYLOAD.
 * @param pg pending group
 */
void PacketProtoEncoder_Init (PacketProtoEncoder *enc, PacketRecvInterface *input, BPendingGroup *pg);

/**
 * Frees the object.
 *
 * @param enc the object
 */
void PacketProtoEncoder_Free (PacketProtoEncoder *enc);

/**
 * Returns the output interface.
 * The MTU of the output interface is PACKETPROTO_ENCLEN(MTU of input interface).
 *
 * @param enc the object
 * @return output interface
 */
PacketRecvInterface * PacketProtoEncoder_GetOutput (PacketProtoEncoder *enc);

#endif
