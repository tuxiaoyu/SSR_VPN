#ifndef URLMATCH_H_INCLUDED
#define URLMATCH_H_INCLUDED
#define URLMATCH_H_VERSION ""

#include "Earth.h"

extern void free_http_request(struct http_request *http);
#ifndef FEATURE_EXTENDED_HOST_PATTERNS
extern jb_err init_domain_components(struct http_request *http);
#endif
extern jb_err parse_http_request(const char *req, struct http_request *http);
extern jb_err parse_http_url(const char *url,
                             struct http_request *http,
                             int require_protocol);
extern int url_requires_percent_encoding(const char *url);

#define REQUIRE_PROTOCOL 1

extern int url_match(const struct pattern_spec *pattern,
                     const struct http_request *http);

extern jb_err create_pattern_spec(struct pattern_spec *url, char *buf);
extern void free_pattern_spec(struct pattern_spec *url);
extern int match_portlist(const char *portlist, int port);
extern jb_err parse_forwarder_address(char *address, char **hostname, int *port);


/* Revision control strings from this header and associated .c file */
extern const char urlmatch_rcs[];
extern const char urlmatch_h_rcs[];

#endif /* ndef URLMATCH_H_INCLUDED */

/*
  Local Variables:
  tab-width: 3
  end:
*/
