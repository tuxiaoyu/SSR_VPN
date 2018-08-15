#include "system/BTime.h"

#ifndef BADVPN_PLUGIN
struct _BTime_global btime_global = {
    #ifndef NDEBUG
    0
    #endif
};
#endif

#ifdef __MACH__
#include <mach/clock.h>
#include <mach/mach.h>

int clock_gettime_ex(int clk_id, struct timespec* t)
{
    clock_serv_t cclock;
    mach_timespec_t mts;
    host_get_clock_service(mach_host_self(), CALENDAR_CLOCK, &cclock);
    clock_get_time(cclock, &mts);
    mach_port_deallocate(mach_task_self(), cclock);
    t->tv_sec = mts.tv_sec;
    t->tv_nsec = mts.tv_nsec;
    return 0;
}
#endif
