#ifndef FILTERS_H_INCLUDED
#define FILTERS_H_INCLUDED
#define FILTERS_H_VERSION ""

#include "Earth.h"

/*
 * ACL checking
 */
#ifdef FEATURE_ACL
extern int block_acl(const struct access_control_addr *dst, const struct client_state *csp);
#endif /* def FEATURE_ACL */
extern int acl_addr(const char *aspec, struct access_control_addr *aca);
/*
 * Interceptors
 */
extern struct http_response *block_url(struct client_state *csp);
extern struct http_response *redirect_url(struct client_state *csp);
#ifdef FEATURE_TRUST
extern struct http_response *trust_url(struct client_state *csp);
#endif /* def FEATURE_TRUST */

/*
 * Request inspectors
 */
#ifdef FEATURE_TRUST
extern int is_untrusted_url(const struct client_state *csp);
#endif /* def FEATURE_TRUST */
#ifdef FEATURE_IMAGE_BLOCKING
extern int is_imageurl(const struct client_state *csp);
#endif /* def FEATURE_IMAGE_BLOCKING */
extern int connect_port_is_forbidden(const struct client_state *csp);

/*
 * Determining applicable actions
 */
extern void get_url_actions(struct client_state *csp,
                            struct http_request *http);
extern int apply_url_actions(struct current_action_spec *action,
                              struct client_state *csp,
                              struct url_actions *b);

extern struct re_filterfile_spec *get_filter(const struct client_state *csp,
                                             const char *requested_name,
                                             enum filter_type requested_type);

/*
 * Determining parent proxies
 */
extern struct forward_spec *forward_url(struct client_state *csp,
                                              const struct http_request *http);

struct url_actions *forward_ip_routing(struct sockaddr_in *addr);

struct forward_spec *forward_ip(struct client_state *csp, struct sockaddr_storage addr);

struct forward_spec *forward_dns_pollution_ip(struct client_state *csp, struct sockaddr_storage addr);

extern struct forward_spec *get_forward_ip_settings(struct client_state *csp);

//static struct forward_spec *get_forward_rule_settings(struct client_state *csp, struct url_actions *url_action, int which);
//
//extern struct forward_spec *get_forward_rule_settings_by_action(struct url_actions *url_action);

/*
 * Content modification
 */
extern char *execute_content_filters(struct client_state *csp);
extern char *execute_single_pcrs_command(char *subject, const char *pcrs_command, int *hits);
extern char *rewrite_url(char *old_url, const char *pcrs_command);
extern char *get_last_url(char *subject, const char *redirect_mode);

extern pcrs_job *compile_dynamic_pcrs_job_list(const struct client_state *csp, const struct re_filterfile_spec *b);

extern int content_requires_filtering(struct client_state *csp);
extern int content_filters_enabled(const struct current_action_spec *action);
extern int filters_available(const struct client_state *csp);

/*
 * Handling Max-Forwards:
 */
extern struct http_response *direct_response(struct client_state *csp);

/*
 * Revision control strings from this header and associated .c file
 */
extern const char filters_rcs[];
extern const char filters_h_rcs[];

#endif /* ndef FILTERS_H_INCLUDED */

/*
  Local Variables:
  tab-width: 3
  end:
*/
