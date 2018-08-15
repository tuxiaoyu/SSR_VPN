#ifndef MISCUTIL_H_INCLUDED
#define MISCUTIL_H_INCLUDED
#define MISCUTIL_H_VERSION ""

#include "Earth.h"

#if defined(__cplusplus)
extern "C" {
#endif

extern const char *basedir;
extern void *zalloc(size_t size);
extern char *strdup_or_die(const char *str);
extern void *malloc_or_die(size_t buffer_size);

#if defined(unix)
extern void write_pid_file(void);
#endif /* unix */

extern unsigned int hash_string(const char* s);

extern int strcmpic(const char *s1, const char *s2);
extern int strncmpic(const char *s1, const char *s2, size_t n);

extern jb_err string_append(char **target_string, const char *text_to_append);
extern jb_err string_join  (char **target_string,       char *text_to_append);
extern char *string_toupper(const char *string);
extern void string_move(char *dst, char *src);

extern char *chomp(char *string);
extern char *bindup(const char *string, size_t len);

extern char *make_path(const char * dir, const char * file);

long int pick_from_range(long int range);

#ifndef HAVE_SNPRINTF
extern int snprintf(char *, size_t, const char *, /*args*/ ...);
#endif /* ndef HAVE_SNPRINTF */

#if !defined(HAVE_TIMEGM) && defined(HAVE_TZSET) && defined(HAVE_PUTENV)
time_t timegm(struct tm *tm);
#endif /* !defined(HAVE_TIMEGM) && defined(HAVE_TZSET) && defined(HAVE_PUTENV) */

/* Here's looking at you, Ulrich. */
#if !defined(HAVE_STRLCPY)
size_t privoxy_strlcpy(char *destination, const char *source, size_t size);
#define strlcpy privoxy_strlcpy
#define USE_PRIVOXY_STRLCPY 1
#define HAVE_STRLCPY 1
#endif /* ndef HAVE_STRLCPY*/

#ifndef HAVE_STRLCAT
size_t privoxy_strlcat(char *destination, const char *source, size_t size);
#define strlcat privoxy_strlcat
#endif /* ndef HAVE_STRLCAT */

/* Revision control strings from this header and associated .c file */
extern const char miscutil_rcs[];
extern const char miscutil_h_rcs[];

#if defined(__cplusplus)
}
#endif

#endif /* ndef MISCUTIL_H_INCLUDED */

/*
  Local Variables:
  tab-width: 3
  end:
*/
