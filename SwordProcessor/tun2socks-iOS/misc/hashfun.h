
#ifndef BADVPN_HASHFUN_H
#define BADVPN_HASHFUN_H

#include <stdint.h>
#include <stddef.h>

static size_t badvpn_djb2_hash (const uint8_t *str)
{
    size_t hash = 5381;
    int c;
    
    while (c = *str++) {
        hash = ((hash << 5) + hash) + c;
    }
    
    return hash;
}

static size_t badvpn_djb2_hash_bin (const uint8_t *str, size_t str_len)
{
    size_t hash = 5381;
    
    while (str_len-- > 0) {
        int c = *str++;
        hash = ((hash << 5) + hash) + c;
    }
    
    return hash;
}

#endif
