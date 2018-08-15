
#ifndef BADVPN_BLOG_SYSLOG_H
#define BADVPN_BLOG_SYSLOG_H

#include "misc/debug.h"
#include "base/BLog.h"

int BLog_InitSyslog (char *ident, char *facility) WARN_UNUSED;

#endif
