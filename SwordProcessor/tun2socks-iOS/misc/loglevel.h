
#ifndef BADVPN_MISC_LOGLEVEL_H
#define BADVPN_MISC_LOGLEVEL_H

#include <string.h>

#include "base/BLog.h"

/**
 * Parses the log level string.
 * 
 * @param str log level string. Recognizes none, error, warning, notice,
 *            info, debug.
 * @return 0 for none, one of BLOG_* for some log level, -1 for unrecognized
 */
static int parse_loglevel (char *str);

int parse_loglevel (char *str)
{
    if (!strcmp(str, "none")) {
        return 0;
    }
    if (!strcmp(str, "error")) {
        return BLOG_ERROR;
    }
    if (!strcmp(str, "warning")) {
        return BLOG_WARNING;
    }
    if (!strcmp(str, "notice")) {
        return BLOG_NOTICE;
    }
    if (!strcmp(str, "info")) {
        return BLOG_INFO;
    }
    if (!strcmp(str, "debug")) {
        return BLOG_DEBUG;
    }
    
    char *endptr;
    long int res = strtol(str, &endptr, 10);
    if (*str && !*endptr && res >= 0 && res <= BLOG_DEBUG) {
        return res;
    }
    
    return -1;
}

#endif
