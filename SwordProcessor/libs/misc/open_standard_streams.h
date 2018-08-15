
#ifndef BADVPN_OPEN_STANDARD_STREAMS_H
#define BADVPN_OPEN_STANDARD_STREAMS_H

#ifndef BADVPN_USE_WINAPI
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#endif

static void open_standard_streams (void)
{
#ifndef BADVPN_USE_WINAPI
    int fd;
    
    do {
        fd = open("/dev/null", O_RDWR);
        if (fd > 2) {
            close(fd);
        }
    } while (fd >= 0 && fd <= 2);
#endif
}

#endif
