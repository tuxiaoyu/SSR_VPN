
#ifndef BADVPN_MISC_CONCAT_STRINGS_H
#define BADVPN_MISC_CONCAT_STRINGS_H

#include <string.h>
#include <stdlib.h>
#include <stdarg.h>

#include "misc/debug.h"

static char * concat_strings (int num, ...)
{
    ASSERT(num >= 0)
    
    // calculate sum of lengths
    size_t sum = 0;
    va_list ap;
    va_start(ap, num);
    for (int i = 0; i < num; i++) {
        const char *str = va_arg(ap, const char *);
        size_t str_len = strlen(str);
        if (str_len > SIZE_MAX - 1 - sum) {
            va_end(ap);
            return NULL;
        }
        sum += str_len;
    }
    va_end(ap);
    
    // allocate memory
    char *res_str = (char *)malloc(sum + 1);
    if (!res_str) {
        return NULL;
    }
    
    // copy strings
    sum = 0;
    va_start(ap, num);
    for (int i = 0; i < num; i++) {
        const char *str = va_arg(ap, const char *);
        size_t str_len = strlen(str);
        memcpy(res_str + sum, str, str_len);
        sum += str_len;
    }
    va_end(ap);
    
    // terminate
    res_str[sum] = '\0';
    
    return res_str;
}

#endif
