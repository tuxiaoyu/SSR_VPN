
#ifndef BADVPN_MISC_NONBLOCKING_H
#define BADVPN_MISC_NONBLOCKING_H

#include <unistd.h>
#include <fcntl.h>

static int badvpn_set_nonblocking (int fd);

int badvpn_set_nonblocking (int fd)
{
    if (fcntl(fd, F_SETFL, O_NONBLOCK) < 0) {
        return 0;
    }
    
    return 1;
}

#endif
