
#ifndef BADVPN_FLOW_PACKETSTREAMSENDER_H
#define BADVPN_FLOW_PACKETSTREAMSENDER_H

#include <stdint.h>

#include "base/DebugObject.h"
#include "flow/PacketPassInterface.h"
#include "flow/StreamPassInterface.h"

/**
 * Object which forwards packets obtained with {@link PacketPassInterface}
 * as a stream with {@link StreamPassInterface} (i.e. it concatenates them).
 */
typedef struct {
    DebugObject d_obj;
    PacketPassInterface input;
    StreamPassInterface *output;
    int in_len;
    uint8_t *in;
    int in_used;
} PacketStreamSender;

/**
 * Initializes the object.
 *
 * @param s the object
 * @param output output interface
 * @param mtu input MTU. Must be >=0.
 * @param pg pending group
 */
void PacketStreamSender_Init (PacketStreamSender *s, StreamPassInterface *output, int mtu, BPendingGroup *pg);

/**
 * Frees the object.
 *
 * @param s the object
 */
void PacketStreamSender_Free (PacketStreamSender *s);

/**
 * Returns the input interface.
 * Its MTU will be as in {@link PacketStreamSender_Init}.
 *
 * @param s the object
 * @return input interface
 */
PacketPassInterface * PacketStreamSender_GetInput (PacketStreamSender *s);

#endif
