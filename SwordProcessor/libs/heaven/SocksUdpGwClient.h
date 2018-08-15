
#ifndef BADVPN_TUN2SOCKS_SOCKSUDPGWCLIENT_H
#define BADVPN_TUN2SOCKS_SOCKSUDPGWCLIENT_H

#include "misc/debug.h"
#include "base/DebugObject.h"
#include "system/BReactor.h"

#ifdef BADVPN_SOCKS_UDP_RELAY
#include <protocol/udpgw_proto.h>
#include <protocol/packetproto.h>
#include <system/BDatagram.h>
#include <flow/PacketBuffer.h>
#include <flow/SinglePacketBuffer.h>
#include <flow/BufferWriter.h>
#include <structure/BAVL.h>
#include <structure/LinkedList1.h>
#include <misc/offset.h>
#else

#include "udpgw_client/UdpGwClient.h"
#include "socksclient/BSocksClient.h"

#endif

typedef void (*SocksUdpGwClient_handler_received)(void *user, BAddr local_addr, BAddr remote_addr, const uint8_t *data, int data_len);

typedef struct {
    int udp_mtu;
    BAddr socks_server_addr;
    const struct BSocksClient_auth_info *auth_info;
    size_t num_auth_info;
    BAddr remote_udpgw_addr;
    BReactor *reactor;
    void *user;
    SocksUdpGwClient_handler_received handler_received;
#ifdef BADVPN_SOCKS_UDP_RELAY
    int udpgw_mtu;
    int num_connections;
    int max_connections;
    BAVL connections_tree;
    LinkedList1 connections_list;
#else
    UdpGwClient udpgw_client;
    BTimer reconnect_timer;
    int have_socks;
    BSocksClient socks_client;
    int socks_up;
#endif
    DebugObject d_obj;
} SocksUdpGwClient;

#ifdef BADVPN_SOCKS_UDP_RELAY
typedef struct {
    BAddr local_addr;
    BAddr remote_addr;
} SocksUdpGwClient_conaddr;

typedef struct {
    SocksUdpGwClient *client;
    SocksUdpGwClient_conaddr conaddr;
    BPending first_job;
    const uint8_t *first_data;
    int first_data_len;
    BDatagram udp_dgram;
    BufferWriter udp_send_writer;
    PacketBuffer udp_send_buffer;
    SinglePacketBuffer udp_recv_buffer;
    PacketPassInterface udp_recv_if;
    BAVLNode connections_tree_node;
    LinkedList1Node connections_list_node;
} SocksUdpGwClient_connection;
#endif

int SocksUdpGwClient_Init(SocksUdpGwClient *o, int udp_mtu, int max_connections, int send_buffer_size, btime_t keepalive_time, BAddr socks_server_addr, const struct BSocksClient_auth_info *auth_info, size_t num_auth_info,
        BAddr remote_udpgw_addr, btime_t reconnect_time, BReactor *reactor, void *user,
        SocksUdpGwClient_handler_received handler_received) WARN_UNUSED;

void SocksUdpGwClient_Free(SocksUdpGwClient *o);

void SocksUdpGwClient_SubmitPacket(SocksUdpGwClient *o, BAddr local_addr, BAddr remote_addr, int is_dns, const uint8_t *data, int data_len);

#endif
