
#ifndef BADVPN_BMUTEX_H
#define BADVPN_BMUTEX_H

#if !defined(BADVPN_THREAD_SAFE) || (BADVPN_THREAD_SAFE != 0 && BADVPN_THREAD_SAFE != 1)
#error BADVPN_THREAD_SAFE is not defined or incorrect
#endif

#if BADVPN_THREAD_SAFE
#include <pthread.h>
#endif

#include "misc/debug.h"
#include "base/DebugObject.h"

typedef struct {
#if BADVPN_THREAD_SAFE
    pthread_mutex_t pthread_mutex;
#endif
    DebugObject d_obj;
} BMutex;

static int BMutex_Init (BMutex *o) WARN_UNUSED;
static void BMutex_Free (BMutex *o);
static void BMutex_Lock (BMutex *o);
static void BMutex_Unlock (BMutex *o);

static int BMutex_Init (BMutex *o)
{
#if BADVPN_THREAD_SAFE
    if (pthread_mutex_init(&o->pthread_mutex, NULL) != 0) {
        return 0;
    }
#endif
    
    DebugObject_Init(&o->d_obj);
    return 1;
}

static void BMutex_Free (BMutex *o)
{
    DebugObject_Free(&o->d_obj);
    
#if BADVPN_THREAD_SAFE
    int res = pthread_mutex_destroy(&o->pthread_mutex);
    B_USE(res)
    ASSERT(res == 0)
#endif
}

static void BMutex_Lock (BMutex *o)
{
    DebugObject_Access(&o->d_obj);
    
#if BADVPN_THREAD_SAFE
    int res = pthread_mutex_lock(&o->pthread_mutex);
    B_USE(res)
    ASSERT(res == 0)
#endif
}

static void BMutex_Unlock (BMutex *o)
{
    DebugObject_Access(&o->d_obj);
    
#if BADVPN_THREAD_SAFE
    int res = pthread_mutex_unlock(&o->pthread_mutex);
    B_USE(res)
    ASSERT(res == 0)
#endif
}

#endif
