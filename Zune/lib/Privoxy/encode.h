#ifndef ENCODE_H_INCLUDED
#define ENCODE_H_INCLUDED
#define ENCODE_H_VERSION ""

extern char * html_encode(const char *s);
extern char * url_encode(const char *s);
extern char * url_decode(const char *str);
extern int    xtoi(const char *s);
extern char * html_encode_and_free_original(char *s);
extern char * percent_encode_url(const char *s);

/* Revision control strings from this header and associated .c file */
extern const char encode_rcs[];
extern const char encode_h_rcs[];

#endif /* ndef ENCODE_H_INCLUDED */

/*
  Local Variables:
  tab-width: 3
  end:
*/
