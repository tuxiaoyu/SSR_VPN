
#ifndef BADVPN_MISC_DEBUGERROR_H
#define BADVPN_MISC_DEBUGERROR_H

#include "misc/debug.h"
#include "base/BPending.h"

#ifndef NDEBUG
    #define DEBUGERROR(de, call) \
        { \
            ASSERT(!BPending_IsSet(&(de)->job)) \
            BPending_Set(&(de)->job); \
            (call); \
        }
#else
    #define DEBUGERROR(de, call) { (call); }
#endif

typedef struct {
    #ifndef NDEBUG
    BPending job;
    #endif
} DebugError;

static void DebugError_Init (DebugError *o, BPendingGroup *pg);
static void DebugError_Free (DebugError *o);
static void DebugError_AssertNoError (DebugError *o);

#ifndef NDEBUG
static void _DebugError_job_handler (DebugError *o)
{
    ASSERT(0);
}
#endif

void DebugError_Init (DebugError *o, BPendingGroup *pg)
{
    #ifndef NDEBUG
    BPending_Init(&o->job, pg, (BPending_handler)_DebugError_job_handler, o);
    #endif
}

void DebugError_Free (DebugError *o)
{
    #ifndef NDEBUG
    BPending_Free(&o->job);
    #endif
}

void DebugError_AssertNoError (DebugError *o)
{
    #ifndef NDEBUG
    ASSERT(!BPending_IsSet(&o->job))
    #endif
}

#endif
