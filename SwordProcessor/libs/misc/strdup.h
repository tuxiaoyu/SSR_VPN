
#ifndef BADVPN_STRDUP_H
#define BADVPN_STRDUP_H

#include <string.h>
#include <stdlib.h>
#include <limits.h>

#include "misc/debug.h"

/**
 * Allocate and copy a null-terminated string.
 */
static char * b_strdup (const char *str)
{
    ASSERT(str)
    
    size_t len = strlen(str);
    
    char *s = (char *)malloc(len + 1);
    if (!s) {
        return NULL;
    }
    
    memcpy(s, str, len + 1);
    
    return s;
}

/**
 * Allocate memory for a null-terminated string and use the
 * given data as its contents. A null terminator is appended
 * after the specified data.
 */
static char * b_strdup_bin (const char *str, size_t len)
{
    ASSERT(str)
    
    if (len == SIZE_MAX) {
        return NULL;
    }
    
    char *s = (char *)malloc(len + 1);
    if (!s) {
        return NULL;
    }
    
    memcpy(s, str, len);
    s[len] = '\0';
    
    return s;
}

#endif
