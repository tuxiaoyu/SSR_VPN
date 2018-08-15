
#ifndef BADVPN_SYSTEM_BSIGNAL_H
#define BADVPN_SYSTEM_BSIGNAL_H

#include "misc/debug.h"
#include "system/BReactor.h"

typedef void (*BSignal_handler) (void *user);

/**
 * Initializes signal handling.
 * The object is created in not capturing state.
 * {@link BLog_Init} must have been done.
 * 
 * WARNING: make sure this won't interfere with other components:
 *   - on Linux, this uses {@link BUnixSignal} to catch SIGTERM and SIGINT,
 *   - on Windows, this sets up a handler with SetConsoleCtrlHandler.
 *
 * @param reactor {@link BReactor} from which the handler will be called
 * @param handler callback function invoked from the reactor
 * @param user value passed to callback function
 * @return 1 on success, 0 on failure
 */
int BSignal_Init (BReactor *reactor, BSignal_handler handler, void *user) WARN_UNUSED;

/**
 * Finishes signal handling.
 * {@link BSignal_Init} must not be called again.
 */
void BSignal_Finish (void);

#endif
