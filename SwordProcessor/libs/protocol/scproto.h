
#ifndef BADVPN_PROTOCOL_SCPROTO_H
#define BADVPN_PROTOCOL_SCPROTO_H

#include <stdint.h>

#include <misc/packed.h>

#define SC_VERSION 29
#define SC_OLDVERSION_NOSSL 27
#define SC_OLDVERSION_BROKENCERT 26

#define SC_KEEPALIVE_INTERVAL 10000

/**
 * SCProto packet header.
 * Follows up to SC_MAX_PAYLOAD bytes of payload.
 */
B_START_PACKED
struct sc_header {
    /**
     * Message type.
     */
    uint8_t type;
} B_PACKED;
B_END_PACKED

#define SC_MAX_PAYLOAD 2000
#define SC_MAX_ENC (sizeof(struct sc_header) + SC_MAX_PAYLOAD)

typedef uint16_t peerid_t;

#define SCID_KEEPALIVE 0
#define SCID_CLIENTHELLO 1
#define SCID_SERVERHELLO 2
#define SCID_NEWCLIENT 3
#define SCID_ENDCLIENT 4
#define SCID_OUTMSG 5
#define SCID_INMSG 6
#define SCID_RESETPEER 7
#define SCID_ACCEPTPEER 8

/**
 * "clienthello" client packet payload.
 * Packet type is SCID_CLIENTHELLO.
 */
B_START_PACKED
struct sc_client_hello {
    /**
     * Protocol version the client is using.
     */
    uint16_t version;
} B_PACKED;
B_END_PACKED

/**
 * "serverhello" server packet payload.
 * Packet type is SCID_SERVERHELLO.
 */
B_START_PACKED
struct sc_server_hello {
    /**
     * Flags. Not used yet.
     */
    uint16_t flags;
    
    /**
     * Peer ID of the client.
     */
    peerid_t id;
    
    /**
     * IPv4 address of the client as seen by the server
     * (network byte order). Zero if not applicable.
     */
    uint32_t clientAddr;
} B_PACKED;
B_END_PACKED

/**
 * "newclient" server packet payload.
 * Packet type is SCID_NEWCLIENT.
 * If the server is using TLS, follows up to SCID_NEWCLIENT_MAX_CERT_LEN
 * bytes of the new client's certificate (encoded in DER).
 */
B_START_PACKED
struct sc_server_newclient {
    /**
     * ID of the new peer.
     */
    peerid_t id;
    
    /**
     * Flags. Possible flags:
     *   - SCID_NEWCLIENT_FLAG_RELAY_SERVER
     *     You can relay frames to other peers through this peer.
     *   - SCID_NEWCLIENT_FLAG_RELAY_CLIENT
     *     You must allow this peer to relay frames to other peers through you.
     *   - SCID_NEWCLIENT_FLAG_SSL
     *     SSL must be used to talk to this peer through messages.
     */
    uint16_t flags;
} B_PACKED;
B_END_PACKED

#define SCID_NEWCLIENT_FLAG_RELAY_SERVER 1
#define SCID_NEWCLIENT_FLAG_RELAY_CLIENT 2
#define SCID_NEWCLIENT_FLAG_SSL 4

#define SCID_NEWCLIENT_MAX_CERT_LEN (SC_MAX_PAYLOAD - sizeof(struct sc_server_newclient))

/**
 * "endclient" server packet payload.
 * Packet type is SCID_ENDCLIENT.
 */
B_START_PACKED
struct sc_server_endclient {
    /**
     * ID of the removed peer.
     */
    peerid_t id;
} B_PACKED;
B_END_PACKED

/**
 * "outmsg" client packet header.
 * Packet type is SCID_OUTMSG.
 * Follows up to SC_MAX_MSGLEN bytes of message payload.
 */
B_START_PACKED
struct sc_client_outmsg {
    /**
     * ID of the destionation peer.
     */
    peerid_t clientid;
} B_PACKED;
B_END_PACKED

/**
 * "inmsg" server packet payload.
 * Packet type is SCID_INMSG.
 * Follows up to SC_MAX_MSGLEN bytes of message payload.
 */
B_START_PACKED
struct sc_server_inmsg {
    /**
     * ID of the source peer.
     */
    peerid_t clientid;
} B_PACKED;
B_END_PACKED

#define _SC_MAX_OUTMSGLEN (SC_MAX_PAYLOAD - sizeof(struct sc_client_outmsg))
#define _SC_MAX_INMSGLEN (SC_MAX_PAYLOAD - sizeof(struct sc_server_inmsg))

#define SC_MAX_MSGLEN (_SC_MAX_OUTMSGLEN < _SC_MAX_INMSGLEN ? _SC_MAX_OUTMSGLEN : _SC_MAX_INMSGLEN)

/**
 * "resetpeer" client packet header.
 * Packet type is SCID_RESETPEER.
 */
B_START_PACKED
struct sc_client_resetpeer {
    /**
     * ID of the peer to reset.
     */
    peerid_t clientid;
} B_PACKED;
B_END_PACKED

/**
 * "acceptpeer" client packet payload.
 * Packet type is SCID_ACCEPTPEER.
 */
B_START_PACKED
struct sc_client_acceptpeer {
    /**
     * ID of the peer to accept.
     */
    peerid_t clientid;
} B_PACKED;
B_END_PACKED

#endif
