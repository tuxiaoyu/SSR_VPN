#include <string.h>
#include <signal.h>

#include "misc/debug.h"
#include "base/BLog.h"

#include "system/BNetwork.h"

#include "generated/blog_channel_BNetwork.h"

extern int bnetwork_initialized;

#ifndef BADVPN_PLUGIN
int bnetwork_initialized = 0;
#endif

int BNetwork_GlobalInit(void) {
    ASSERT(!bnetwork_initialized)

    struct sigaction act;
    memset(&act, 0, sizeof(act));
    act.sa_handler = SIG_IGN;
    sigemptyset(&act.sa_mask);
    act.sa_flags = 0;
    if (sigaction(SIGPIPE, &act, NULL) < 0) {
        BLog(BLOG_ERROR, "sigaction failed");
        goto fail0;
    }

    bnetwork_initialized = 1;

    return 1;

    fail0:
    return 0;
}

void BNetwork_Assert(void) {
    ASSERT(bnetwork_initialized)
}
