
#include "DebugObject.h"

#ifndef BADVPN_PLUGIN
#ifndef NDEBUG
DebugCounter debugobject_counter = DEBUGCOUNTER_STATIC;
#if BADVPN_THREAD_SAFE
pthread_mutex_t debugobject_mutex = PTHREAD_MUTEX_INITIALIZER;
#endif
#endif
#endif
