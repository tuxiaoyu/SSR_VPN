
#ifndef BADVPN_PROTOCOL_MSGPROTO_H
#define BADVPN_PROTOCOL_MSGPROTO_H

#include <generated/bproto_msgproto.h>

#define MSGID_YOUCONNECT 1
#define MSGID_CANNOTCONNECT 2
#define MSGID_CANNOTBIND 3
#define MSGID_YOURETRY 5
#define MSGID_SEED 6
#define MSGID_CONFIRMSEED 7

#define MSG_MAX_PAYLOAD (SC_MAX_MSGLEN - msg_SIZEtype - msg_SIZEpayload(0))

#endif
