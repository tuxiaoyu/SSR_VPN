
#ifndef BADVPN_WRITE_FILE_H
#define BADVPN_WRITE_FILE_H

#include <stddef.h>
#include <stdint.h>
#include <stdio.h>

#include <misc/debug.h>
#include <misc/memref.h>

static int write_file (const char *file, MemRef data)
{
    FILE *f = fopen(file, "w");
    if (!f) {
        goto fail0;
    }
    
    while (data.len > 0) {
        size_t res = fwrite(data.ptr, 1, data.len, f);
        if (res == 0) {
            goto fail1;
        }
        
        ASSERT(res <= data.len)
        
        data = MemRef_SubFrom(data, res);
    }
    
    if (fclose(f) != 0) {
        return 0;
    }
    
    return 1;
    
fail1:
    fclose(f);
fail0:
    return 0;
}

#endif
