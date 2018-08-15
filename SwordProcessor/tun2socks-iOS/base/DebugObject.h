
#ifndef BADVPN_DEBUGOBJECT_H
#define BADVPN_DEBUGOBJECT_H

#include <stdint.h>

#if !defined(BADVPN_THREAD_SAFE) || (BADVPN_THREAD_SAFE != 0 && BADVPN_THREAD_SAFE != 1)
#error BADVPN_THREAD_SAFE is not defined or incorrect
#endif

#if BADVPN_THREAD_SAFE
#include <pthread.h>
#endif

#include "misc/debug.h"
#include "misc/debugcounter.h"

#define DEBUGOBJECT_VALID UINT32_C(0x31415926)

/**
 * Object used for detecting leaks.
 */
typedef struct {
    #ifndef NDEBUG
    uint32_t c;
    #endif
} DebugObject;

/**
 * Initializes the object.
 * 
 * @param obj the object
 */
static void DebugObject_Init (DebugObject *obj);

/**
 * Frees the object.
 * 
 * @param obj the object
 */
static void DebugObject_Free (DebugObject *obj);

/**
 * Does nothing.
 * 
 * @param obj the object
 */
static void DebugObject_Access (const DebugObject *obj);

/**
 * Does nothing.
 * There must be no {@link DebugObject}'s initialized.
 */
static void DebugObjectGlobal_Finish (void);

#ifndef NDEBUG
extern DebugCounter debugobject_counter;
#if BADVPN_THREAD_SAFE
extern pthread_mutex_t debugobject_mutex;
#endif
#endif

void DebugObject_Init (DebugObject *obj)
{
    #ifndef NDEBUG
    
    obj->c = DEBUGOBJECT_VALID;
    
    #if BADVPN_THREAD_SAFE
    ASSERT_FORCE(pthread_mutex_lock(&debugobject_mutex) == 0)
    #endif
    
    DebugCounter_Increment(&debugobject_counter);
    
    #if BADVPN_THREAD_SAFE
    ASSERT_FORCE(pthread_mutex_unlock(&debugobject_mutex) == 0)
    #endif
    
    #endif
}

void DebugObject_Free (DebugObject *obj)
{
    ASSERT(obj->c == DEBUGOBJECT_VALID)
    
    #ifndef NDEBUG
    
    obj->c = 0;
    
    #if BADVPN_THREAD_SAFE
    ASSERT_FORCE(pthread_mutex_lock(&debugobject_mutex) == 0)
    #endif
    
    DebugCounter_Decrement(&debugobject_counter);
    
    #if BADVPN_THREAD_SAFE
    ASSERT_FORCE(pthread_mutex_unlock(&debugobject_mutex) == 0)
    #endif
    
    #endif
}

void DebugObject_Access (const DebugObject *obj)
{
    ASSERT(obj->c == DEBUGOBJECT_VALID)
}

void DebugObjectGlobal_Finish (void)
{
    #ifndef NDEBUG
    DebugCounter_Free(&debugobject_counter);
    #endif
}

#endif
