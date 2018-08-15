
#ifndef BADVPN_MISC_LOGGERSSTRING_H
#define BADVPN_MISC_LOGGERSSTRING_H

#ifdef BADVPN_USE_WINAPI
#define LOGGERS_STRING "stdout"
#else
#define LOGGERS_STRING "stdout/syslog"
#endif

#endif
