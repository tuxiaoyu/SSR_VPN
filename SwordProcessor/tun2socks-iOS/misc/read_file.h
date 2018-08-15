
#ifndef BADVPN_MISC_READ_FILE_H
#define BADVPN_MISC_READ_FILE_H

#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>

static int read_file (const char *file, uint8_t **out_data, size_t *out_len)
{
    FILE *f = fopen(file, "r");
    if (!f) {
        goto fail0;
    }
    
    size_t buf_len = 0;
    size_t buf_size = 128;
    
    uint8_t *buf = (uint8_t *)malloc(buf_size);
    if (!buf) {
        goto fail1;
    }
    
    while (1) {
        if (buf_len == buf_size) {
            if (2 > SIZE_MAX / buf_size) {
                goto fail;
            }
            size_t newsize = 2 * buf_size;
            
            uint8_t *newbuf = (uint8_t *)realloc(buf, newsize);
            if (!newbuf) {
                goto fail;
            }
            
            buf = newbuf;
            buf_size = newsize;
        }
        
        size_t bytes = fread(buf + buf_len, 1, buf_size - buf_len, f);
        if (bytes == 0) {
            if (feof(f)) {
                break;
            }
            goto fail;
        }
        
        buf_len += bytes;
    }
    
    fclose(f);
    
    *out_data = buf;
    *out_len = buf_len;
    return 1;
    
fail:
    free(buf);
fail1:
    fclose(f);
fail0:
    return 0;
}

#endif
