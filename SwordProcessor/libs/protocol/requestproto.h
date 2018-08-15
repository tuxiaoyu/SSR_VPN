
#ifndef BADVPN_REQUESTPROTO_H
#define BADVPN_REQUESTPROTO_H

#include <stdint.h>

#include <misc/packed.h>

#define REQUESTPROTO_TYPE_CLIENT_REQUEST 1
#define REQUESTPROTO_TYPE_CLIENT_ABORT 2
#define REQUESTPROTO_TYPE_SERVER_REPLY 3
#define REQUESTPROTO_TYPE_SERVER_FINISHED 4
#define REQUESTPROTO_TYPE_SERVER_ERROR 5

B_START_PACKED
struct requestproto_header {
    uint32_t request_id;
    uint32_t type;
} B_PACKED;
B_END_PACKED

#endif
