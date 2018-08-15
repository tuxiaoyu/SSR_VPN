
#include "misc/debugerror.h"
#include "base/DebugObject.h"

#define BCONNECTION_SEND_LIMIT 2
#define BCONNECTION_RECV_LIMIT 2
#define BCONNECTION_LISTEN_BACKLOG 128

struct BListener_s {
    BReactor *reactor;
    void *user;
    BListener_handler handler;
    char *unix_socket_path;
    int fd;
    BFileDescriptor bfd;
    BPending default_job;
    DebugObject d_obj;
};

struct BConnector_s {
    BReactor *reactor;
    void *user;
    BConnector_handler handler;
    BPending job;
    int fd;
    int connected;
    int have_bfd;
    BFileDescriptor bfd;
    DebugObject d_obj;
};

struct BConnection_s {
    BReactor *reactor;
    void *user;
    BConnection_handler handler;
    int fd;
    int close_fd;
    int is_hupd;
    BFileDescriptor bfd;
    int wait_events;
    struct {
        BReactorLimit limit;
        StreamPassInterface iface;
        BPending job;
        const uint8_t *busy_data;
        int busy_data_len;
        int state;
    } send;
    struct {
        BReactorLimit limit;
        StreamRecvInterface iface;
        BPending job;
        uint8_t *busy_data;
        int busy_data_avail;
        int state;
    } recv;
    DebugError d_err;
    DebugObject d_obj;
};
