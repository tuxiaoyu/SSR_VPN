
#ifndef BADVPN_FLOW_PACKETPROTODECODER_H
#define BADVPN_FLOW_PACKETPROTODECODER_H

#include <stdint.h>

#include "protocol/packetproto.h"
#include "misc/debug.h"
#include "base/DebugObject.h"
#include "flow/StreamRecvInterface.h"
#include "flow/PacketPassInterface.h"

/**
 * Handler called when a protocol error occurs.
 * When an error occurs, the decoder is reset to the initial state.
 * 
 * @param user as in {@link PacketProtoDecoder_Init}
 */
typedef void (*PacketProtoDecoder_handler_error) (void *user);

typedef struct {
    StreamRecvInterface *input;
    PacketPassInterface *output;
    void *user;
    PacketProtoDecoder_handler_error handler_error;
    int output_mtu;
    int buf_size;
    int buf_start;
    int buf_used;
    uint8_t *buf;
    DebugObject d_obj;
} PacketProtoDecoder;

/**
 * Initializes the object.
 *
 * @param enc the object
 * @param input input interface. The decoder will accept packets with payload size up to its MTU
 *              (but the payload can never be more than PACKETPROTO_MAXPAYLOAD).
 * @param output output interface
 * @param pg pending group
 * @param user argument to handlers
 * @param handler_error error handler
 * @return 1 on success, 0 on failure
 */
int PacketProtoDecoder_Init (PacketProtoDecoder *enc, StreamRecvInterface *input, PacketPassInterface *output, BPendingGroup *pg, void *user, PacketProtoDecoder_handler_error handler_error) WARN_UNUSED;

/**
 * Frees the object.
 *
 * @param enc the object
 */
void PacketProtoDecoder_Free (PacketProtoDecoder *enc);

/**
 * Clears the internal buffer.
 * The next data received from the input will be treated as a new
 * PacketProto stream.
 *
 * @param enc the object
 */
void PacketProtoDecoder_Reset (PacketProtoDecoder *enc);

#endif
