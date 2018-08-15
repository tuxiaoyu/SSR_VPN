#ifndef CGISIMPLE_H_INCLUDED
#define CGISIMPLE_H_INCLUDED
#define CGISIMPLE_H_VERSION ""

#include "Earth.h"

/*
 * CGI functions
 */
extern jb_err cgi_default      (struct client_state *csp,
                                struct http_response *rsp,
                                const struct map *parameters);
extern jb_err cgi_error_404    (struct client_state *csp,
                                struct http_response *rsp,
                                const struct map *parameters);
extern jb_err cgi_robots_txt   (struct client_state *csp,
                                struct http_response *rsp,
                                const struct map *parameters);
extern jb_err cgi_send_banner  (struct client_state *csp,
                                struct http_response *rsp,
                                const struct map *parameters);
extern jb_err cgi_show_status  (struct client_state *csp,
                                struct http_response *rsp,
                                const struct map *parameters);
extern jb_err cgi_show_url_info(struct client_state *csp,
                                struct http_response *rsp,
                                const struct map *parameters);
extern jb_err cgi_show_version (struct client_state *csp,
                                struct http_response *rsp,
                                const struct map *parameters);
extern jb_err cgi_show_request (struct client_state *csp,
                                struct http_response *rsp,
                                const struct map *parameters);
extern jb_err cgi_transparent_image (struct client_state *csp,
                                     struct http_response *rsp,
                                     const struct map *parameters);
extern jb_err cgi_send_error_favicon (struct client_state *csp,
                                      struct http_response *rsp,
                                      const struct map *parameters);
extern jb_err cgi_send_default_favicon (struct client_state *csp,
                                        struct http_response *rsp,
                                        const struct map *parameters);
extern jb_err cgi_send_stylesheet(struct client_state *csp,
                                  struct http_response *rsp,
                                  const struct map *parameters);
extern jb_err cgi_send_url_info_osd(struct client_state *csp,
                                    struct http_response *rsp,
                                    const struct map *parameters);
extern jb_err cgi_send_user_manual(struct client_state *csp,
                                   struct http_response *rsp,
                                   const struct map *parameters);


#ifdef FEATURE_GRACEFUL_TERMINATION
extern jb_err cgi_die (struct client_state *csp,
                       struct http_response *rsp,
                       const struct map *parameters);
#endif

/* Revision control strings from this header and associated .c file */
extern const char cgisimple_rcs[];
extern const char cgisimple_h_rcs[];

#endif /* ndef CGISIMPLE_H_INCLUDED */

/*
  Local Variables:
  tab-width: 3
  end:
*/
