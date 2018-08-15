
#ifndef BADVPN_B_REF_TARGET_H
#define BADVPN_B_REF_TARGET_H

#include <limits.h>

#include <misc/debug.h>
#include <base/DebugObject.h>

/**
 * Represents a reference-counted object.
 */
typedef struct BRefTarget_s BRefTarget;

/**
 * Callback function called after the reference count of a {@link BRefTarget}
 * reaches has reached zero. At this point the BRefTarget object has already
 * been invalidated, i.e. {@link BRefTarget_Ref} must not be called on this
 * object after this handler is called.
 */
typedef void (*BRefTarget_func_release) (BRefTarget *o);

struct BRefTarget_s {
    BRefTarget_func_release func_release;
    int refcnt;
    DebugObject d_obj;
};

/**
 * Initializes a reference target object. The initial reference count of the object
 * is 1. The \a func_release argument specifies the function to be called from
 * {@link BRefTarget_Deref} when the reference count reaches zero.
 */
static void BRefTarget_Init (BRefTarget *o, BRefTarget_func_release func_release);

/**
 * Decrements the reference count of a reference target object. If the reference
 * count has reached zero, the object's {@link BRefTarget_func_release} function
 * is called, and the object is considered destroyed.
 */
static void BRefTarget_Deref (BRefTarget *o);

/**
 * Increments the reference count of a reference target object.
 * Returns 1 on success and 0 on failure.
 */
static int BRefTarget_Ref (BRefTarget *o) WARN_UNUSED;

static void BRefTarget_Init (BRefTarget *o, BRefTarget_func_release func_release)
{
    ASSERT(func_release)
    
    o->func_release = func_release;
    o->refcnt = 1;
    
    DebugObject_Init(&o->d_obj);
}

static void BRefTarget_Deref (BRefTarget *o)
{
    DebugObject_Access(&o->d_obj);
    ASSERT(o->refcnt > 0)
    
    o->refcnt--;
    
    if (o->refcnt == 0) {
        DebugObject_Free(&o->d_obj);
        o->func_release(o);
    }
}

static int BRefTarget_Ref (BRefTarget *o)
{
    DebugObject_Access(&o->d_obj);
    ASSERT(o->refcnt > 0)
    
    if (o->refcnt == INT_MAX) {
        return 0;
    }
    
    o->refcnt++;
    
    return 1;
}

#endif
