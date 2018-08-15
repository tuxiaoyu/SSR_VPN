#ifndef SHIP_H_INCLUDED
#define SHIP_H_INCLUDED
#define SHIP_H_VERSION ""

#include "Earth.h"

struct client_state;
struct file_list;

#ifdef FEATURE_STATISTICS
extern int urls_read;
extern int urls_rejected;
#endif

extern struct client_states clients[1];
extern struct file_list files[1];

extern int daemon_mode;

#if defined(FEATURE_PTHREAD) || defined(_WIN32)
#define MUTEX_LOCKS_AVAILABLE

#include <pthread.h>
typedef pthread_mutex_t privoxy_mutex_t;

static struct configuration_spec *config;

extern void privoxy_mutex_lock(privoxy_mutex_t *mutex);
extern void privoxy_mutex_unlock(privoxy_mutex_t *mutex);

extern privoxy_mutex_t log_mutex;
extern privoxy_mutex_t log_init_mutex;
extern privoxy_mutex_t connection_reuse_mutex;
extern privoxy_mutex_t resolver_mutex;

#endif /* FEATURE_PTHREAD */

typedef void (*ShipTunnel_cb)(int fd, void *);

extern int island_main(char *conf_path, struct forward_spec *forward_proxy_list, ShipTunnel_cb cb, void *data);

extern struct log_client_states *log_clients;

extern void log_time_stage(struct client_state *csp, enum time_stage stage);

extern void log_request_error(struct client_state *csp, int error_code);

extern const char jcc_rcs[];
extern const char jcc_h_rcs[];

#endif
