
#ifndef BADVPN_FIND_PROGRAM_H
#define BADVPN_FIND_PROGRAM_H

#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#include <misc/concat_strings.h>
#include <misc/debug.h>
#include <misc/balloc.h>

static char * badvpn_find_program (const char *name);

static char * badvpn_find_program (const char *name)
{
    ASSERT(name)
    
    char *path = getenv("PATH");
    if (path) {
        while (1) {
            size_t i = 0;
            while (path[i] != ':' && path[i] != '\0') {
                i++;
            }
            char const *src = path;
            size_t src_len = i;
            if (src_len == 0) {
                src = ".";
                src_len = 1;
            }
            size_t name_len = strlen(name);
            char *entry = BAllocSize(bsize_add(bsize_fromsize(src_len), bsize_add(bsize_fromsize(name_len), bsize_fromsize(2))));
            if (!entry) {
                goto fail;
            }
            memcpy(entry, src, src_len);
            entry[src_len] = '/';
            strcpy(entry + (src_len + 1), name);
            if (access(entry, X_OK) == 0) {
                return entry;
            }
            free(entry);
            if (path[i] == '\0') {
                break;
            }
            path += i + 1;
        }
    }
    
    const char *dirs[] = {"/usr/sbin", "/usr/bin", "/sbin", "/bin", NULL};
    
    for (size_t i = 0; dirs[i]; i++) {
        char *try_path = concat_strings(3, dirs[i], "/", name);
        if (!try_path) {
            goto fail;
        }
        
        if (access(try_path, X_OK) == 0) {
            return try_path;
        }
        
        free(try_path);
    }
    
fail:
    return NULL;
}

#endif
