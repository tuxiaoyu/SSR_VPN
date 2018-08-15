#ifndef CGIEDIT_H_INCLUDED
#define CGIEDIT_H_INCLUDED
#define CGIEDIT_H_VERSION ""

#include "Earth.h"

/*
 * CGI functions
 */
#ifdef FEATURE_CGI_EDIT_ACTIONS
extern jb_err cgi_edit_actions        (struct client_state *csp,
                                       struct http_response *rsp,
                                       const struct map *parameters);
extern jb_err cgi_edit_actions_for_url(struct client_state *csp,
                                       struct http_response *rsp,
                                       const struct map *parameters);
extern jb_err cgi_edit_actions_list   (struct client_state *csp,
                                       struct http_response *rsp,
                                       const struct map *parameters);
extern jb_err cgi_edit_actions_submit (struct client_state *csp,
                                       struct http_response *rsp,
                                       const struct map *parameters);
extern jb_err cgi_edit_actions_url    (struct client_state *csp,
                                       struct http_response *rsp,
                                       const struct map *parameters);
extern jb_err cgi_edit_actions_url_form(struct client_state *csp,
                                        struct http_response *rsp,
                                        const struct map *parameters);
extern jb_err cgi_edit_actions_add_url(struct client_state *csp,
                                       struct http_response *rsp,
                                       const struct map *parameters);
extern jb_err cgi_edit_actions_add_url_form(struct client_state *csp,
                                            struct http_response *rsp,
                                            const struct map *parameters);
extern jb_err cgi_edit_actions_remove_url    (struct client_state *csp,
                                              struct http_response *rsp,
                                              const struct map *parameters);
extern jb_err cgi_edit_actions_remove_url_form(struct client_state *csp,
                                            struct http_response *rsp,
                                            const struct map *parameters);
extern jb_err cgi_edit_actions_section_remove(struct client_state *csp,
                                              struct http_response *rsp,
                                              const struct map *parameters);
extern jb_err cgi_edit_actions_section_add   (struct client_state *csp,
                                              struct http_response *rsp,
                                              const struct map *parameters);
extern jb_err cgi_edit_actions_section_swap  (struct client_state *csp,
                                              struct http_response *rsp,
                                              const struct map *parameters);
#endif /* def FEATURE_CGI_EDIT_ACTIONS */
#ifdef FEATURE_TOGGLE
extern jb_err cgi_toggle(struct client_state *csp,
                         struct http_response *rsp,
                         const struct map *parameters);
#endif /* def FEATURE_TOGGLE */

/* Revision control strings from this header and associated .c file */
extern const char cgiedit_rcs[];
extern const char cgiedit_h_rcs[];

#endif /* ndef CGI_H_INCLUDED */

/*
  Local Variables:
  tab-width: 3
  end:
*/
