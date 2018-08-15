
#include <stddef.h>
#include <string.h>

#include "protocol/packetproto.h"
#include "misc/balign.h"
#include "misc/debug.h"
#include "misc/byteorder.h"

#include "flow/PacketProtoEncoder.h"

static void output_handler_recv (PacketProtoEncoder *enc, uint8_t *data)
{
    ASSERT(!enc->output_packet)
    ASSERT(data)
    DebugObject_Access(&enc->d_obj);
    
    // schedule receive
    enc->output_packet = data;
    PacketRecvInterface_Receiver_Recv(enc->input, enc->output_packet + sizeof(struct packetproto_header));
}

static void input_handler_done (PacketProtoEncoder *enc, int in_len)
{
    ASSERT(enc->output_packet)
    DebugObject_Access(&enc->d_obj);
    
    // write length
    struct packetproto_header pp;
    pp.len = htol16(in_len);
    memcpy(enc->output_packet, &pp, sizeof(pp));
    
    // finish output packet
    enc->output_packet = NULL;
    PacketRecvInterface_Done(&enc->output, PACKETPROTO_ENCLEN(in_len));
}

void PacketProtoEncoder_Init (PacketProtoEncoder *enc, PacketRecvInterface *input, BPendingGroup *pg)
{
    ASSERT(PacketRecvInterface_GetMTU(input) <= PACKETPROTO_MAXPAYLOAD)
    
    // init arguments
    enc->input = input;
    
    // init input
    PacketRecvInterface_Receiver_Init(enc->input, (PacketRecvInterface_handler_done)input_handler_done, enc);
    
    // init output
    PacketRecvInterface_Init(
        &enc->output, PACKETPROTO_ENCLEN(PacketRecvInterface_GetMTU(enc->input)),
        (PacketRecvInterface_handler_recv)output_handler_recv, enc, pg
    );
    
    // set no output packet
    enc->output_packet = NULL;
    
    DebugObject_Init(&enc->d_obj);
}

void PacketProtoEncoder_Free (PacketProtoEncoder *enc)
{
    DebugObject_Free(&enc->d_obj);

    // free input
    PacketRecvInterface_Free(&enc->output);
}

PacketRecvInterface * PacketProtoEncoder_GetOutput (PacketProtoEncoder *enc)
{
    DebugObject_Access(&enc->d_obj);
    
    return &enc->output;
}
