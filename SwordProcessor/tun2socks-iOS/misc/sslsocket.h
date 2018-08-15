
#ifndef BADVPN_MISC_SSLSOCKET_H
#define BADVPN_MISC_SSLSOCKET_H

#include <prio.h>

#include <system/BConnection.h>
#include <nspr_support/BSSLConnection.h>

typedef struct {
    BConnection con;
    PRFileDesc bottom_prfd;
    PRFileDesc *ssl_prfd;
} sslsocket;

#endif
