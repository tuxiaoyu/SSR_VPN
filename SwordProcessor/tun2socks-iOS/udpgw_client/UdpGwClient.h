#ifndef BADVPN_UDPGW_CLIENT_UDPGWCLIENT_H
#define BADVPN_UDPGW_CLIENT_UDPGWCLIENT_H

#include <stdint.h>

#include "protocol/udpgw_proto.h"
#include "misc/debug.h"
#include "misc/packed.h"
#include "structure/BAVL.h"
#include "structure/LinkedList1.h"
#include "base/DebugObject.h"
#include "system/BAddr.h"
#include "base/BPending.h"
#include "flow/PacketPassFairQueue.h"
#include "flow/PacketStreamSender.h"
#include "flow/PacketProtoFlow.h"
#include "flow/PacketProtoDecoder.h"
#include "flow/PacketPassConnector.h"
#include "flowextra/PacketPassInactivityMonitor.h"

typedef void (*UdpGwClient_handler_servererror)(void *user);

typedef void (*UdpGwClient_handler_received)(void *user, BAddr local_addr, BAddr remote_addr, const uint8_t *data, int data_len);

B_START_PACKED
struct UdpGwClient__keepalive_packet {
    struct packetproto_header pp;
    struct udpgw_header udpgw;
} B_PACKED;
B_END_PACKED

typedef struct {
    int udp_mtu;
    int max_connections;
    int send_buffer_size;
    btime_t keepalive_time;
    BReactor *reactor;
    void *user;
    UdpGwClient_handler_servererror handler_servererror;
    UdpGwClient_handler_received handler_received;
    int udpgw_mtu;
    int pp_mtu;
    BAVL connections_tree_by_conaddr;
    BAVL connections_tree_by_conid;
    LinkedList1 connections_list;
    int num_connections;
    int next_conid;
    PacketPassFairQueue send_queue;
    PacketPassInactivityMonitor send_monitor;
    PacketPassConnector send_connector;
    struct UdpGwClient__keepalive_packet keepalive_packet;
    PacketPassInterface *keepalive_if;
    PacketPassFairQueueFlow keepalive_qflow;
    int keepalive_sending;
    int have_server;
    PacketStreamSender send_sender;
    PacketProtoDecoder recv_decoder;
    PacketPassInterface recv_if;
    DebugObject d_obj;
} UdpGwClient;

struct UdpGwClient_conaddr {
    BAddr local_addr;
    BAddr remote_addr;
};

struct UdpGwClient_connection {
    UdpGwClient *client;
    struct UdpGwClient_conaddr conaddr;
    uint8_t first_flags;
    const uint8_t *first_data;
    int first_data_len;
    uint16_t conid;
    BPending first_job;
    BufferWriter *send_if;
    PacketProtoFlow send_ppflow;
    PacketPassFairQueueFlow send_qflow;
    BAVLNode connections_tree_by_conaddr_node;
    BAVLNode connections_tree_by_conid_node;
    LinkedList1Node connections_list_node;
};

int UdpGwClient_Init(UdpGwClient *o, int udp_mtu, int max_connections, int send_buffer_size, btime_t keepalive_time, BReactor *reactor, void *user,
        UdpGwClient_handler_servererror handler_servererror,
        UdpGwClient_handler_received handler_received) WARN_UNUSED;

void UdpGwClient_Free(UdpGwClient *o);

void UdpGwClient_SubmitPacket(UdpGwClient *o, BAddr local_addr, BAddr remote_addr, int is_dns, const uint8_t *data, int data_len);

int UdpGwClient_ConnectServer(UdpGwClient *o, StreamPassInterface *send_if, StreamRecvInterface *recv_if) WARN_UNUSED;

void UdpGwClient_DisconnectServer(UdpGwClient *o);

#endif
