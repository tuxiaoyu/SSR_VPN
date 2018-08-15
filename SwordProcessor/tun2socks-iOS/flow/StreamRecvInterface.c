
#include "flow/StreamRecvInterface.h"

void _StreamRecvInterface_job_operation (StreamRecvInterface *i)
{
    ASSERT(i->state == SRI_STATE_OPERATION_PENDING)
    DebugObject_Access(&i->d_obj);
    
    // set state
    i->state = SRI_STATE_BUSY;
    
    // call handler
    i->handler_operation(i->user_provider, i->job_operation_data, i->job_operation_len);
    return;
}

void _StreamRecvInterface_job_done (StreamRecvInterface *i)
{
    ASSERT(i->state == SRI_STATE_DONE_PENDING)
    DebugObject_Access(&i->d_obj);
    
    // set state
    i->state = SRI_STATE_NONE;
    
    // call handler
    i->handler_done(i->user_user, i->job_done_len);
    return;
}
