
#ifndef BADVPN_STDBUF_CMDLINE_H
#define BADVPN_STDBUF_CMDLINE_H

#include <string.h>

#include <misc/debug.h>
#include <misc/cmdline.h>
#include <misc/balloc.h>

/**
 * Builds the initial part of command line for calling a program via stdbuf
 * with standard output buffering set to line-buffered.
 * 
 * @param out {@link CmdLine} to append the result to. Note than on failure, only
 *            some part of the cmdline may have been appended.
 * @param stdbuf_exec full path to stdbuf executable
 * @param exec path to the executable. Must not contain nulls. 
 * @param exec_len number of characters in exec
 * @return 1 on success, 0 on failure
 */
static int build_stdbuf_cmdline (CmdLine *out, const char *stdbuf_exec, const char *exec, size_t exec_len) WARN_UNUSED;

int build_stdbuf_cmdline (CmdLine *out, const char *stdbuf_exec, const char *exec, size_t exec_len)
{
    ASSERT(!memchr(exec, '\0', exec_len))
    
    if (!CmdLine_AppendMulti(out, 3, stdbuf_exec, "-o", "L")) {
        goto fail1;
    }
    
    if (exec[0] == '/') {
        if (!CmdLine_AppendNoNull(out, exec, exec_len)) {
            goto fail1;
        }
    } else {
        bsize_t size = bsize_add(bsize_fromsize(exec_len), bsize_fromsize(3));
        char *real_exec = BAllocSize(size);
        if (!real_exec) {
            goto fail1;
        }
        
        memcpy(real_exec, "./", 2);
        memcpy(real_exec + 2, exec, exec_len);
        real_exec[2 + exec_len] = '\0';
        
        int res = CmdLine_Append(out, real_exec);
        free(real_exec);
        if (!res) {
            goto fail1;
        }
    }
    
    return 1;
    
fail1:
    return 0;
}

#endif
