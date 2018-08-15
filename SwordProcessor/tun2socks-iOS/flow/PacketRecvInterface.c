
#include "flow/PacketRecvInterface.h"

void _PacketRecvInterface_job_operation (PacketRecvInterface *i)
{
    ASSERT(i->state == PRI_STATE_OPERATION_PENDING)
    DebugObject_Access(&i->d_obj);
    
    // set state
    i->state = PRI_STATE_BUSY;
    
    // call handler
    i->handler_operation(i->user_provider, i->job_operation_data);
    return;
}

void _PacketRecvInterface_job_done (PacketRecvInterface *i)
{
    ASSERT(i->state == PRI_STATE_DONE_PENDING)
    DebugObject_Access(&i->d_obj);
    
    // set state
    i->state = PRI_STATE_NONE;
    
    // call handler
    i->handler_done(i->user_user, i->job_done_len);
    return;
}
