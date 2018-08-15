#include <string.h>
#include <stdio.h>

#include <fcntl.h>
#include <unistd.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/socket.h>

#include <netinet/ip.h>
#include <sys/uio.h>

#include "base/BLog.h"

#include "tuntap/BTap.h"

#include "TunnelInterface.h"

static void report_error(BTap *o);

static void output_handler_recv(BTap *o, uint8_t *data);

static inline int header_modify_read_write_return(int len) {
    if (len > 0) {
        return len > sizeof(u_int32_t) ? len - sizeof(u_int32_t) : 0;
    } else {
        return len;
    }
}

static int write_tun_header(int fd, void *buf, size_t len) {
    u_int32_t type;
    struct iovec iv[2];
    struct ip *iph;

    iph = (struct ip *) buf;

    if (iph->ip_v == 6) {
        type = htonl(AF_INET6);
    } else {
        type = htonl(AF_INET);
    }

    iv[0].iov_base = &type;
    iv[0].iov_len = sizeof(type);
    iv[1].iov_base = buf;
    iv[1].iov_len = len;

    return header_modify_read_write_return(writev(fd, iv, 2));
}

static int read_tun_header(int fd, void *buf, size_t len) {
    u_int32_t type;
    struct iovec iv[2];

    iv[0].iov_base = &type;
    iv[0].iov_len = sizeof(type);
    iv[1].iov_base = buf;
    iv[1].iov_len = len;

    return header_modify_read_write_return(readv(fd, iv, 2));
}

static void fd_handler(BTap *o, int events) {
    DebugObject_Access(&o->d_obj);
    DebugError_AssertNoError(&o->d_err);

    if (events & (BREACTOR_ERROR | BREACTOR_HUP)) {
        BLog(BLOG_WARNING, "device fd reports error?");
    }

    if (events & BREACTOR_READ)
        do {
            ASSERT(o->output_packet)

            // try reading into the buffer
#ifdef __APPLE__
            //        int bytes = read_tun_header(o->fd, o->output_packet, o->frame_mtu);
            uint8_t data[2];
            int bytes = read(o->fd, data, 2);
            if (bytes != 2) {
                // Treat zero return value the same as EAGAIN.
                // See: https://bugzilla.kernel.org/show_bug.cgi?id=96381
//            if (bytes == 0 || errno == EAGAIN || errno == EWOULDBLOCK) {
//                // retry later
//                break;
//            }
//            // report fatal error
//            report_error(o);
//            return;
                break;
            }
            int data_len = data[0] * 256 + data[1];

            bytes = read(o->fd, o->output_packet, data_len);
#else
            int bytes = read(o->fd, o->output_packet, o->frame_mtu);
#endif
            if (bytes != data_len) {
                // report fatal error
                report_error(o);
                return;
            }
            if (bytes <= 0) {
                // Treat zero return value the same as EAGAIN.
                // See: https://bugzilla.kernel.org/show_bug.cgi?id=96381
                if (bytes == 0 || errno == EAGAIN || errno == EWOULDBLOCK) {
                    // retry later
                    break;
                }
                // report fatal error
                report_error(o);
                return;
            }

#if TCP_DATA_LOG_ENABLE
                BLog(BLOG_DEBUG, "tun2socks receive from tunnel data<len: %d>", bytes);
#endif

            ASSERT_FORCE(bytes <= o->frame_mtu)

            // set no output packet
            o->output_packet = NULL;

            // update events
            o->poll_events &= ~BREACTOR_READ;
            BReactor_SetFileDescriptorEvents(o->reactor, &o->bfd, o->poll_events);

            // inform receiver we finished the packet
            PacketRecvInterface_Done(&o->output, bytes);
        } while (0);
}

void report_error(BTap *o) {
    DEBUGERROR(&o->d_err, o->handler_error(o->handler_error_user));
}

void output_handler_recv(BTap *o, uint8_t *data) {
    DebugObject_Access(&o->d_obj);
    DebugError_AssertNoError(&o->d_err);
    ASSERT(data)
    ASSERT(!o->output_packet)

    o->output_packet = data;
    // update events
    o->poll_events |= BREACTOR_READ;
    BReactor_SetFileDescriptorEvents(o->reactor, &o->bfd, o->poll_events);
}

int BTap_Init(BTap *o, BReactor *reactor, int fd, int mtu, BTap_handler_error handler_error, void *handler_error_user, int tun) {
    ASSERT(tun == 0 || tun == 1)

    struct BTap_init_data init_data;
    init_data.dev_type = tun ? BTAP_DEV_TUN : BTAP_DEV_TAP;
    init_data.init_type = BTAP_INIT_FD;
    init_data.init.fd.fd = fd;
    init_data.init.fd.mtu = mtu;

    return BTap_Init2(o, reactor, init_data, handler_error, handler_error_user);
}

int BTap_Init2(BTap *o, BReactor *reactor, struct BTap_init_data init_data, BTap_handler_error handler_error, void *handler_error_user) {
    ASSERT(init_data.dev_type == BTAP_DEV_TUN || init_data.dev_type == BTAP_DEV_TAP)

    // init arguments
    o->reactor = reactor;
    o->handler_error = handler_error;
    o->handler_error_user = handler_error_user;

#if defined(BADVPN_LINUX) || defined(BADVPN_FREEBSD)

    o->close_fd = (init_data.init_type != BTAP_INIT_FD);

    switch (init_data.init_type) {
        case BTAP_INIT_FD: {
            ASSERT(init_data.init.fd.fd >= 0)
            ASSERT(init_data.init.fd.mtu >= 0)
            ASSERT(init_data.dev_type != BTAP_DEV_TAP || init_data.init.fd.mtu >= BTAP_ETHERNET_HEADER_LENGTH)

            o->fd = init_data.init.fd.fd;
            o->frame_mtu = init_data.init.fd.mtu;
        }
            break;

        case BTAP_INIT_STRING:
            break;

        default: ASSERT(0);
    }

    // set non-blocking
    if (fcntl(o->fd, F_SETFL, O_NONBLOCK) < 0) {
        BLog(BLOG_ERROR, "cannot set non-blocking");
        goto fail1;
    }

    // init file descriptor object
    BFileDescriptor_Init(&o->bfd, o->fd, (BFileDescriptor_handler) fd_handler, o);
    if (!BReactor_AddFileDescriptor(o->reactor, &o->bfd)) {
        BLog(BLOG_ERROR, "BReactor_AddFileDescriptor failed");
        goto fail1;
    }
    o->poll_events = 0;

    goto success;

    fail1:
    if (o->close_fd) {
        ASSERT_FORCE(close(o->fd) == 0)
    }
    fail0:
    return 0;

#endif

    success:
    // init output
    PacketRecvInterface_Init(&o->output, o->frame_mtu, (PacketRecvInterface_handler_recv) output_handler_recv, o, BReactor_PendingGroup(o->reactor));

    // set no output packet
    o->output_packet = NULL;

    DebugError_Init(&o->d_err, BReactor_PendingGroup(o->reactor));
    DebugObject_Init(&o->d_obj);
    return 1;
}

void BTap_Free(BTap *o) {
    DebugObject_Free(&o->d_obj);
    DebugError_Free(&o->d_err);

    // free output
    PacketRecvInterface_Free(&o->output);

    // free BFileDescriptor
    BReactor_RemoveFileDescriptor(o->reactor, &o->bfd);

    if (o->close_fd) {
        // close file descriptor
        ASSERT_FORCE(close(o->fd) == 0)
    }
}

int BTap_GetMTU(BTap *o) {
    DebugObject_Access(&o->d_obj);

    return o->frame_mtu;
}

void BTap_Send(BTap *o, uint8_t *data, int data_len) {
    DebugObject_Access(&o->d_obj);
    DebugError_AssertNoError(&o->d_err);
    ASSERT(data_len >= 0)
    ASSERT(data_len <= o->frame_mtu)

    //    int bytes = write_tun_header(o->fd, data, data_len);
    NSData *outdata = [[NSData alloc] initWithBytes:data length:data_len];

    int bytes = write(o->fd, data, data_len);
    if (bytes < 0) {
        // malformed packets will cause errors, ignore them and act like
        // the packet was accepeted
    } else {
        if (bytes != data_len + 2) {
            BLog(BLOG_WARNING, "written %d expected %d", bytes, data_len + 2);
        }
    }
}

PacketRecvInterface *BTap_GetOutput(BTap *o) {
    DebugObject_Access(&o->d_obj);

    return &o->output;
}
