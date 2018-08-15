/**
 * @file
 *
 * AutoIP Automatic LinkLocal IP Configuration
 */


#ifndef __LWIP_AUTOIP_H__
#define __LWIP_AUTOIP_H__

#include "lwip/opt.h"

#if LWIP_AUTOIP /* don't build if not configured for use in lwipopts.h */

#include "lwip/netif.h"
#include "lwip/udp.h"
#include "netif/etharp.h"

#ifdef __cplusplus
extern "C" {
#endif

/* AutoIP Timing */
#define AUTOIP_TMR_INTERVAL      100
#define AUTOIP_TICKS_PER_SECOND (1000 / AUTOIP_TMR_INTERVAL)

/* RFC 3927 Constants */
#define PROBE_WAIT               1   /* second   (initial random delay)                 */
#define PROBE_MIN                1   /* second   (minimum delay till repeated probe)    */
#define PROBE_MAX                2   /* seconds  (maximum delay till repeated probe)    */
#define PROBE_NUM                3   /*          (number of probe packets)              */
#define ANNOUNCE_NUM             2   /*          (number of announcement packets)       */
#define ANNOUNCE_INTERVAL        2   /* seconds  (time between announcement packets)    */
#define ANNOUNCE_WAIT            2   /* seconds  (delay before announcing)              */
#define MAX_CONFLICTS            10  /*          (max conflicts before rate limiting)   */
#define RATE_LIMIT_INTERVAL      60  /* seconds  (delay between successive attempts)    */
#define DEFEND_INTERVAL          10  /* seconds  (min. wait between defensive ARPs)     */

/* AutoIP client states */
#define AUTOIP_STATE_OFF         0
#define AUTOIP_STATE_PROBING     1
#define AUTOIP_STATE_ANNOUNCING  2
#define AUTOIP_STATE_BOUND       3

struct autoip
{
  ip_addr_t llipaddr;       /* the currently selected, probed, announced or used LL IP-Address */
  u8_t state;               /* current AutoIP state machine state */
  u8_t sent_num;            /* sent number of probes or announces, dependent on state */
  u16_t ttw;                /* ticks to wait, tick is AUTOIP_TMR_INTERVAL long */
  u8_t lastconflict;        /* ticks until a conflict can be solved by defending */
  u8_t tried_llipaddr;      /* total number of probed/used Link Local IP-Addresses */
};


#define autoip_init() /* Compatibility define, no init needed. */

/** Set a struct autoip allocated by the application to work with */
void autoip_set_struct(struct netif *netif, struct autoip *autoip);

/** Start AutoIP client */
err_t autoip_start(struct netif *netif);

/** Stop AutoIP client */
err_t autoip_stop(struct netif *netif);

/** Handles every incoming ARP Packet, called by etharp_arp_input */
void autoip_arp_reply(struct netif *netif, struct etharp_hdr *hdr);

/** Has to be called in loop every AUTOIP_TMR_INTERVAL milliseconds */
void autoip_tmr(void);

/** Handle a possible change in the network configuration */
void autoip_network_changed(struct netif *netif);

#ifdef __cplusplus
}
#endif

#endif /* LWIP_AUTOIP */

#endif /* __LWIP_AUTOIP_H__ */
