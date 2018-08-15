#ifndef _ISLAND_H
#define _ISLAND_H

typedef struct {
    /*  Required  */
    char *remote_host;
    char *local_addr;
    char *method;
    char *password;
    int remote_port;
    int local_port;
    int timeout;

    /* SSR */
    char *protocol;
    char *obfs;
    char *obfs_param;

    /*  Optional, set NULL if not valid   */
    char *acl;
    char *log;
    int use_sys_log;
    int fast_open;
    int mode;
    int auth;
    int mtu;
    int mptcp;
    int verbose;
} island_profile;

typedef void (*island_cb)(int fd, void *);

int start_ss_local_server(island_profile profile, island_cb cb, void *data);

#endif
