
#ifndef BADVPN_FIND_CHAR_H
#define BADVPN_FIND_CHAR_H

#include <stddef.h>

#include "misc/debug.h"

/**
 * Finds the first character 'c' in the string represented by 'str' and 'len'.
 * If found, returns 1 and writes the position to *out_pos (if out_pos!=NULL).
 * If not found, returns 0 and does not modify *out_pos.
 */
static int b_find_char_bin (const char *str, size_t len, char c, size_t *out_pos)
{
    ASSERT(str)
    
    for (size_t i = 0; i < len; i++) {
        if (str[i] == c) {
            if (out_pos) {
                *out_pos = i;
            }
            return 1;
        }
    }
    
    return 0;
}

#endif
