
#ifndef BADVPN_MISC_DEBUGCOUNTER_H
#define BADVPN_MISC_DEBUGCOUNTER_H

#include <stdint.h>

#include "misc/debug.h"

/**
 * Counter for detecting leaks.
 */
typedef struct {
#ifndef NDEBUG
    int32_t c;
#endif
} DebugCounter;

#ifndef NDEBUG
#define DEBUGCOUNTER_STATIC { 0 }
#else
#define DEBUGCOUNTER_STATIC {}
#endif

/**
 * Initializes the object.
 * The object is initialized with counter value zero.
 * 
 * @param obj the object
 */
static void DebugCounter_Init (DebugCounter *obj)
{
#ifndef NDEBUG
    obj->c = 0;
#endif
}

/**
 * Frees the object.
 * This does not have to be called when the counter is no longer needed.
 * The counter value must be zero.
 * 
 * @param obj the object
 */
static void DebugCounter_Free (DebugCounter *obj)
{
#ifndef NDEBUG
    ASSERT(obj->c == 0 || obj->c == INT32_MAX)
#endif
}

/**
 * Increments the counter.
 * Increments the counter value by one.
 * 
 * @param obj the object
 */
static void DebugCounter_Increment (DebugCounter *obj)
{
#ifndef NDEBUG
    ASSERT(obj->c >= 0)
    
    if (obj->c != INT32_MAX) {
        obj->c++;
    }
#endif
}

/**
 * Decrements the counter.
 * The counter value must be >0.
 * Decrements the counter value by one.
 * 
 * @param obj the object
 */
static void DebugCounter_Decrement (DebugCounter *obj)
{
#ifndef NDEBUG
    ASSERT(obj->c > 0)
    
    if (obj->c != INT32_MAX) {
        obj->c--;
    }
#endif
}

#endif
