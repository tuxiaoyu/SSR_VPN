
#include "flow/StreamPassInterface.h"

void _StreamPassInterface_job_operation (StreamPassInterface *i)
{
    ASSERT(i->state == SPI_STATE_OPERATION_PENDING)
    DebugObject_Access(&i->d_obj);
    
    // set state
    i->state = SPI_STATE_BUSY;
    
    // call handler
    i->handler_operation(i->user_provider, i->job_operation_data, i->job_operation_len);
    return;
}

void _StreamPassInterface_job_done (StreamPassInterface *i)
{
    ASSERT(i->state == SPI_STATE_DONE_PENDING)
    DebugObject_Access(&i->d_obj);
    
    // set state
    i->state = SPI_STATE_NONE;
    
    // call handler
    i->handler_done(i->user_user, i->job_done_len);
    return;
}
