
#ifndef LWIP_CUSTOM_LWIPOPTS_H
#define LWIP_CUSTOM_LWIPOPTS_H

#define NO_SYS 1
#define MEM_ALIGNMENT 4

#define LWIP_ARP 0
#define ARP_QUEUEING 0
#define IP_FORWARD 0
#define LWIP_ICMP 1
#define LWIP_RAW 0
#define LWIP_DHCP 0
#define LWIP_AUTOIP 0
#define LWIP_SNMP 0
#define LWIP_IGMP 0
#define LWIP_DNS 0
#define LWIP_UDP 1
#define LWIP_UDPLITE 0
#define LWIP_TCP 1
#define LWIP_CALLBACK_API 1
#define LWIP_NETIF_API 0
#define LWIP_NETIF_LOOPBACK 0
#define LWIP_HAVE_LOOPIF 0
#define LWIP_HAVE_SLIPIF 0
#define LWIP_NETCONN 0
#define LWIP_SOCKET 0
#define PPP_SUPPORT 0
#define LWIP_IPV6 0
#define LWIP_IPV6_MLD 0
#define LWIP_IPV6_AUTOCONFIG 0

#define LWIP_CHECKSUM_ON_COPY 1

// MEM
#define MEM_SIZE                        (1024 * 1024 * 2) /* 1MiB */
#define MEMP_NUM_PBUF 256
#define MEMP_NUM_TCP_PCB 256
#define MEMP_NUM_TCP_PCB_LISTEN 256
#define MEMP_NUM_TCP_SEG 256
#define MEMP_NUM_REASSDATA 256
#define MEMP_NUM_FRAG_PBUF 256
#define PBUF_POOL_SIZE 256

//#define MEMP_NUM_TCP_PCB_LISTEN 16
//#define MEMP_NUM_TCP_PCB 1024
//#define TCP_SND_BUF 32469
//#define TCP_SND_QUEUELEN (4 * (TCP_SND_BUF)/(TCP_MSS))

#define MEM_LIBC_MALLOC 1
#define MEMP_MEM_MALLOC 1

//#define TCP_MSS 8117

#define TCP_MSS                         2048
#define TCP_WND                         (2*TCP_MSS)
#define TCP_SND_BUF                     2 * TCP_WND
#define TCP_OVERSIZE                    TCP_MSS
#define TCP_SND_QUEUELEN                TCP_SNDQUEUELEN_OVERFLOW


//#define LWIP_DEBUG
#define TCP_DEBUG                LWIP_DBG_ON
#define IP_DEBUG                LWIP_DBG_ON
#define TCP_INPUT_DEBUG         LWIP_DBG_ON
#define TCP_WND_DEBUG           LWIP_DBG_ON
#define TCP_OUTPUT_DEBUG        LWIP_DBG_ON
#define TCP_RST_DEBUG       LWIP_DBG_ON
#define TCP_QLEN_DEBUG      LWIP_DBG_ON
#endif
