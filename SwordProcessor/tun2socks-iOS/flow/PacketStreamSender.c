
#include <stdlib.h>

#include "misc/debug.h"

#include "flow/PacketStreamSender.h"

static void send_data (PacketStreamSender *s)
{
    ASSERT(s->in_len >= 0)
    
    if (s->in_used < s->in_len) {
        // send more data
        StreamPassInterface_Sender_Send(s->output, s->in + s->in_used, s->in_len - s->in_used);
    } else {
        // finish input packet
        s->in_len = -1;
        PacketPassInterface_Done(&s->input);
    }
}

static void input_handler_send (PacketStreamSender *s, uint8_t *data, int data_len)
{
    ASSERT(s->in_len == -1)
    ASSERT(data_len >= 0)
    DebugObject_Access(&s->d_obj);
    
    // set input packet
    s->in_len = data_len;
    s->in = data;
    s->in_used = 0;
    
    // send
    send_data(s);
}

static void output_handler_done (PacketStreamSender *s, int data_len)
{
    ASSERT(s->in_len >= 0)
    ASSERT(data_len > 0)
    ASSERT(data_len <= s->in_len - s->in_used)
    DebugObject_Access(&s->d_obj);
    
    // update number of bytes sent
    s->in_used += data_len;
    
    // send
    send_data(s);
}

void PacketStreamSender_Init (PacketStreamSender *s, StreamPassInterface *output, int mtu, BPendingGroup *pg)
{
    ASSERT(mtu >= 0)
    
    // init arguments
    s->output = output;
    
    // init input
    PacketPassInterface_Init(&s->input, mtu, (PacketPassInterface_handler_send)input_handler_send, s, pg);
    
    // init output
    StreamPassInterface_Sender_Init(s->output, (StreamPassInterface_handler_done)output_handler_done, s);
    
    // have no input packet
    s->in_len = -1;
    
    DebugObject_Init(&s->d_obj);
}

void PacketStreamSender_Free (PacketStreamSender *s)
{
    DebugObject_Free(&s->d_obj);
    
    // free input
    PacketPassInterface_Free(&s->input);
}

PacketPassInterface * PacketStreamSender_GetInput (PacketStreamSender *s)
{
    DebugObject_Access(&s->d_obj);
    
    return &s->input;
}
