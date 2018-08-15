
#include <stdio.h>
#include <Foundation/Foundation.h>

#include "BLog.h"

#ifndef BADVPN_PLUGIN

struct _BLog_channel blog_channel_list[] = {
#include "generated/blog_channels_list.h"
};

struct _BLog_global blog_global = {
#ifndef NDEBUG
        0
#endif
};

#endif

// keep in sync with level numbers in BLog.h!
static char *level_names[] = {NULL, "ERROR", "WARNING", "NOTICE", "INFO", "DEBUG"};

static void stdout_log(int channel, int level, const char *msg) {
    NSLog(@"%s(%s): %s\n", level_names[level], blog_global.channels[channel].name, msg);
}

static void stderr_log(int channel, int level, const char *msg) {
    NSLog(@"%s(%s): %s\n", level_names[level], blog_global.channels[channel].name, msg);
}

static void stdout_stderr_free(void) {
}

void BLog_InitStdout(void) {
    BLog_Init(stdout_log, stdout_stderr_free);
}

void BLog_InitStderr(void) {
    BLog_Init(stderr_log, stdout_stderr_free);
}
