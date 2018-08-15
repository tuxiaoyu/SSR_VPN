
#ifndef BADVPN_MISC_SOCKS_PROTO_H
#define BADVPN_MISC_SOCKS_PROTO_H

#include <stdint.h>

#include "misc/packed.h"

#define SOCKS_VERSION 0x05

#define SOCKS_METHOD_NO_AUTHENTICATION_REQUIRED 0x00
#define SOCKS_METHOD_GSSAPI 0x01
#define SOCKS_METHOD_USERNAME_PASSWORD 0x02
#define SOCKS_METHOD_NO_ACCEPTABLE_METHODS 0xFF

#define SOCKS_CMD_CONNECT 0x01
#define SOCKS_CMD_BIND 0x02
#define SOCKS_CMD_UDP_ASSOCIATE 0x03

#define SOCKS_ATYP_IPV4 0x01
#define SOCKS_ATYP_DOMAINNAME 0x03
#define SOCKS_ATYP_IPV6 0x04

#define SOCKS_REP_SUCCEEDED 0x00
#define SOCKS_REP_GENERAL_FAILURE 0x01
#define SOCKS_REP_CONNECTION_NOT_ALLOWED 0x02
#define SOCKS_REP_NETWORK_UNREACHABLE 0x03
#define SOCKS_REP_HOST_UNREACHABLE 0x04
#define SOCKS_REP_CONNECTION_REFUSED 0x05
#define SOCKS_REP_TTL_EXPIRED 0x06
#define SOCKS_REP_COMMAND_NOT_SUPPORTED 0x07
#define SOCKS_REP_ADDRESS_TYPE_NOT_SUPPORTED 0x08

B_START_PACKED
struct socks_client_hello_header {
    uint8_t ver;
    uint8_t nmethods;
} B_PACKED;
B_END_PACKED

B_START_PACKED
struct socks_client_hello_method {
    uint8_t method;
} B_PACKED;
B_END_PACKED

B_START_PACKED
struct socks_server_hello {
    uint8_t ver;
    uint8_t method;
} B_PACKED;
B_END_PACKED

B_START_PACKED
struct socks_request_header {
    uint8_t ver;
    uint8_t cmd;
    uint8_t rsv;
    uint8_t atyp;
} B_PACKED;
B_END_PACKED

B_START_PACKED
struct socks_reply_header {
    uint8_t ver;
    uint8_t rep;
    uint8_t rsv;
    uint8_t atyp;
} B_PACKED;
B_END_PACKED

B_START_PACKED
struct socks_addr_ipv4 {
    uint32_t addr;
    uint16_t port;
} B_PACKED;
B_END_PACKED

B_START_PACKED
struct socks_addr_ipv6 {
    uint8_t addr[16];
    uint16_t port;
} B_PACKED;    
B_END_PACKED

#endif
