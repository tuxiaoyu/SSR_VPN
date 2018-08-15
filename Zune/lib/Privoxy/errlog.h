#ifndef ERRLOG_H_INCLUDED
#define ERRLOG_H_INCLUDED
#define ERRLOG_H_VERSION ""
/* Debug level for errors */

/* XXX: Should be renamed. */
#define LOG_LEVEL_GPC        0x0001
#define LOG_LEVEL_CONNECT    0x0002
#define LOG_LEVEL_IO         0x0004
#define LOG_LEVEL_HEADER     0x0008
#define LOG_LEVEL_WRITING    0x0010
#ifdef FEATURE_FORCE_LOAD
#define LOG_LEVEL_FORCE      0x0020
#endif /* def FEATURE_FORCE_LOAD */
#define LOG_LEVEL_RE_FILTER  0x0040
#define LOG_LEVEL_REDIRECTS  0x0080
#define LOG_LEVEL_DEANIMATE  0x0100
#define LOG_LEVEL_CLF        0x0200 /* Common Log File format */
#define LOG_LEVEL_CRUNCH     0x0400
#define LOG_LEVEL_CGI        0x0800 /* CGI / templates */
#define LOG_LEVEL_RECEIVED   0x8000
#define LOG_LEVEL_ACTIONS   0x10000

/* Following are always on: */
#define LOG_LEVEL_INFO    0x1000
#define LOG_LEVEL_ERROR   0x2000
#define LOG_LEVEL_FATAL   0x4000 /* Exits after writing log */

extern void init_error_log(const char *prog_name, const char *logfname);
extern void set_debug_level(int debuglevel);
extern int  debug_level_is_enabled(int debuglevel);
extern void disable_logging(void);
extern void init_log_module(void);
extern void show_version(const char *prog_name);
extern void log_error(int loglevel, const char *fmt, ...);
extern const char *jb_err_to_string(int jb_error);

/* Revision control strings from this header and associated .c file */
extern const char errlog_rcs[];
extern const char errlog_h_rcs[];

#endif /* ndef ERRLOG_H_INCLUDED */

