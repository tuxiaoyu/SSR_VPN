#include "misc/debugerror.h"
#include "base/DebugObject.h"

#define BDATAGRAM_SEND_LIMIT 2
#define BDATAGRAM_RECV_LIMIT 2

struct BDatagram_s {
    BReactor *reactor;
    void *user;
    BDatagram_handler handler;
    int fd;
    BFileDescriptor bfd;
    int wait_events;
    struct {
        BReactorLimit limit;
        int have_addrs;
        BAddr remote_addr;
        BIPAddr local_addr;
        int inited;
        int mtu;
        PacketPassInterface iface;
        BPending job;
        int busy;
        const uint8_t *busy_data;
        int busy_data_len;
    } send;
    struct {
        BReactorLimit limit;
        int started;
        int have_addrs;
        BAddr remote_addr;
        BIPAddr local_addr;
        int inited;
        int mtu;
        PacketRecvInterface iface;
        BPending job;
        int busy;
        uint8_t *busy_data;
    } recv;
    DebugError d_err;
    DebugObject d_obj;
};
