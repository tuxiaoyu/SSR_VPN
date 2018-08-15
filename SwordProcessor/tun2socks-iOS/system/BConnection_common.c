
#include "BConnection.h"

int BListener_Init(BListener *o, BAddr addr, BReactor *reactor, void *user,
        BListener_handler handler) {
    return BListener_InitFrom(o, BLisCon_from_addr(addr), reactor, user, handler);
}

#ifndef BADVPN_USE_WINAPI

int BListener_InitUnix(BListener *o, const char *socket_path, BReactor *reactor, void *user,
        BListener_handler handler) {
    return BListener_InitFrom(o, BLisCon_from_unix(socket_path), reactor, user, handler);
}

#endif

int BConnector_Init(BConnector *o, BAddr addr, BReactor *reactor, void *user,
        BConnector_handler handler) {
    return BConnector_InitFrom(o, BLisCon_from_addr(addr), reactor, user, handler);
}

#ifndef BADVPN_USE_WINAPI

int BConnector_InitUnix(BConnector *o, const char *socket_path, BReactor *reactor, void *user,
        BConnector_handler handler) {
    return BConnector_InitFrom(o, BLisCon_from_unix(socket_path), reactor, user, handler);
}

#endif
