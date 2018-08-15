
#ifndef BADVPN_MISC_STRING_BEGINS_WITH
#define BADVPN_MISC_STRING_BEGINS_WITH

#include <stddef.h>
#include <string.h>

#include <misc/debug.h>

static size_t data_begins_with (const char *str, size_t str_len, const char *needle)
{
    ASSERT(strlen(needle) > 0)
    
    size_t len = 0;
    
    while (str_len > 0 && *needle) {
        if (*str != *needle) {
            return 0;
        }
        str++;
        str_len--;
        needle++;
        len++;
    }
    
    if (*needle) {
        return 0;
    }
    
    return len;
}

static size_t string_begins_with (const char *str, const char *needle)
{
    ASSERT(strlen(needle) > 0)
    
    return data_begins_with(str, strlen(str), needle);
}

static size_t data_begins_with_bin (const char *str, size_t str_len, const char *needle, size_t needle_len)
{
    ASSERT(needle_len > 0)
    
    size_t len = 0;
    
    while (str_len > 0 && needle_len > 0) {
        if (*str != *needle) {
            return 0;
        }
        str++;
        str_len--;
        needle++;
        needle_len--;
        len++;
    }
    
    if (needle_len > 0) {
        return 0;
    }
    
    return len;
}

#endif
