
#include "flow/PacketPassInterface.h"

void _PacketPassInterface_job_operation (PacketPassInterface *i)
{
    ASSERT(i->state == PPI_STATE_OPERATION_PENDING)
    DebugObject_Access(&i->d_obj);
    
    // set state
    i->state = PPI_STATE_BUSY;
    
    // call handler
    i->handler_operation(i->user_provider, i->job_operation_data, i->job_operation_len);
    return;
}

void _PacketPassInterface_job_requestcancel (PacketPassInterface *i)
{
    ASSERT(i->state == PPI_STATE_BUSY)
    ASSERT(i->cancel_requested)
    ASSERT(i->handler_requestcancel)
    DebugObject_Access(&i->d_obj);
    
    // call handler
    i->handler_requestcancel(i->user_provider);
    return;
}

void _PacketPassInterface_job_done (PacketPassInterface *i)
{
    ASSERT(i->state == PPI_STATE_DONE_PENDING)
    DebugObject_Access(&i->d_obj);
    
    // set state
    i->state = PPI_STATE_NONE;
    
    // call handler
    i->handler_done(i->user_user);
    return;
}
