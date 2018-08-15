
#ifndef BADVPN_GETIFACEINFO_H
#define BADVPN_GETIFACEINFO_H

#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <unistd.h>
#include <sys/socket.h>
#include <net/if.h>
#include <net/if_arp.h>
#include <sys/ioctl.h>

#include <misc/debug.h>

/**
 * Returns information about a network interface with the given name.
 * 
 * @param ifname name of interface to get information for
 * @param out_mac the MAC address will be returned here, unless NULL
 * @param out_mtu the MTU will be returned here, unless NULL
 * @param out_ifindex the interface index will be returned here, unless NULL
 * @return 1 on success, 0 on failure
 */
static int badvpn_get_iface_info (const char *ifname, uint8_t *out_mac, int *out_mtu, int *out_ifindex) WARN_UNUSED;


static int badvpn_get_iface_info (const char *ifname, uint8_t *out_mac, int *out_mtu, int *out_ifindex)
{
    ASSERT(ifname)
    
    struct ifreq ifr;
    
    int s = socket(AF_INET, SOCK_DGRAM, 0);
    if (s < 0) {
        goto fail0;
    }
    
    // get MAC
    if (out_mac) {
        memset(&ifr, 0, sizeof(ifr));
        snprintf(ifr.ifr_name, sizeof(ifr.ifr_name), "%s", ifname);
        if (ioctl(s, SIOCGIFHWADDR, &ifr)) {
            goto fail1;
        }
        if (ifr.ifr_hwaddr.sa_family != ARPHRD_ETHER) {
            goto fail1;
        }
        memcpy(out_mac, ifr.ifr_hwaddr.sa_data, 6);
    }
    
    // get MTU
    if (out_mtu) {
        memset(&ifr, 0, sizeof(ifr));
        snprintf(ifr.ifr_name, sizeof(ifr.ifr_name), "%s", ifname);
        if (ioctl(s, SIOCGIFMTU, &ifr)) {
            goto fail1;
        }
        *out_mtu = ifr.ifr_mtu;
    }
    
    // get interface index
    if (out_ifindex) {
        memset(&ifr, 0, sizeof(ifr));
        snprintf(ifr.ifr_name, sizeof(ifr.ifr_name), "%s", ifname);
        if (ioctl(s, SIOCGIFINDEX, &ifr)) {
            goto fail1;
        }
        *out_ifindex = ifr.ifr_ifindex;
    }
    
    close(s);
    
    return 1;
    
fail1:
    close(s);
fail0:
    return 0;
}

#endif
