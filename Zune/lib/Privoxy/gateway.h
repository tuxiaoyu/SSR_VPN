#ifndef GATEWAY_H_INCLUDED
#define GATEWAY_H_INCLUDED
#define GATEWAY_H_VERSION ""

struct forward_spec;
struct http_request;
struct client_state;

extern jb_socket forwarded_connect(const struct forward_spec * fwd,
                                   struct http_request *http,
                                   struct client_state *csp);

/*
 * Default number of seconds after which an
 * open connection will no longer be reused.
 */
#define DEFAULT_KEEP_ALIVE_TIMEOUT 180

#ifdef FEATURE_CONNECTION_SHARING
extern void set_keep_alive_timeout(unsigned int timeout);
extern void initialize_reusable_connections(void);
extern void forget_connection(jb_socket sfd);
extern void remember_connection(const struct reusable_connection *connection);
extern int close_unusable_connections(void);
#endif /* FEATURE_CONNECTION_SHARING */

extern void mark_connection_closed(struct reusable_connection *closed_connection);
#ifdef FEATURE_CONNECTION_KEEP_ALIVE
extern int connection_destination_matches(const struct reusable_connection *connection,
                                          const struct http_request *http,
                                          const struct forward_spec *fwd);
#endif /* def FEATURE_CONNECTION_KEEP_ALIVE */

extern jb_socket socks4_connect(char *gateway_host,
                                int gateway_port,
                                enum forwarder_type type,
                                const char * target_host,
                                int target_port,
                                struct client_state *csp);

extern jb_socket socks5_connect(char *gateway_host,
                         int gateway_port,
                         enum forwarder_type type,
                         const char *target_host,
                         int target_port,
                                struct client_state *csp);
/*
 * Revision control strings from this header and associated .c file
 */
extern const char gateway_rcs[];
extern const char gateway_h_rcs[];

#endif /* ndef GATEWAY_H_INCLUDED */

/*
  Local Variables:
  tab-width: 3
  end:
*/
