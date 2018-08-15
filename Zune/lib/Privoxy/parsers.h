#ifndef PARSERS_H_INCLUDED
#define PARSERS_H_INCLUDED
#define PARSERS_H_VERSION ""

#include "Earth.h"

/* Used for sed()'s second argument. */
#define FILTER_CLIENT_HEADERS 0
#define FILTER_SERVER_HEADERS 1

extern long flush_socket(jb_socket fd, struct iob *iob);
extern jb_err add_to_iob(struct iob *iob, const size_t buffer_limit, char *src, long n);
extern void clear_iob(struct iob *iob);
extern jb_err decompress_iob(struct client_state *csp);
extern char *get_header(struct iob *iob);
extern char *get_header_value(const struct list *header_list, const char *header_name);
extern jb_err sed(struct client_state *csp, int filter_server_headers);
extern jb_err update_server_headers(struct client_state *csp);
extern void get_http_time(int time_offset, char *buf, size_t buffer_size);
extern jb_err get_destination_from_headers(const struct list *headers, struct http_request *http);
extern unsigned long long get_expected_content_length(struct list *headers);
extern jb_err client_transfer_encoding(struct client_state *csp, char **header);

#ifdef FEATURE_FORCE_LOAD
extern int strclean(char *string, const char *substring);
#endif /* def FEATURE_FORCE_LOAD */

/* Revision control strings from this header and associated .c file */
extern const char parsers_rcs[];
extern const char parsers_h_rcs[];

#endif /* ndef PARSERS_H_INCLUDED */

/*
  Local Variables:
  tab-width: 3
  end:
*/
