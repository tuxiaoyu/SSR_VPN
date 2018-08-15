
#include "system/BTime.h"

#include "lwip/sys.h"

u32_t sys_now (void)
{
    return btime_gettime();
}
