
#ifndef BADVPN_PACKETPASSINACTIVITYMONITOR_H
#define BADVPN_PACKETPASSINACTIVITYMONITOR_H

#include "base/DebugObject.h"
#include "system/BReactor.h"
#include "flow/PacketPassInterface.h"

/**
 * Handler function invoked when inactivity is detected.
 * It is guaranteed that the interfaces are in not sending state.
 *
 * @param user value given to {@link PacketPassInactivityMonitor_Init}
 */
typedef void (*PacketPassInactivityMonitor_handler) (void *user);

/**
 * A {@link PacketPassInterface} layer for detecting inactivity.
 * It reports inactivity to a user provided handler function.
 *
 * The object behaves like that:
 * ("timer set" means started with the given timeout whether if was running or not,
 * "timer unset" means stopped if it was running)
 *     - There is a timer.
 *     - The timer is set when the object is initialized.
 *     - When the input calls Send, the call is passed on to the output.
 *       If the output accepted the packet, the timer is set. If the output
 *       blocked the packet, the timer is unset.
 *     - When the output calls Done, the timer is set, and the call is
 *       passed on to the input.
 *     - When the input calls Cancel, the timer is set, and the call is
 *       passed on to the output.
 *     - When the timer expires, the timer is set, ant the user's handler
 *       function is invoked.
 */
typedef struct {
    DebugObject d_obj;
    PacketPassInterface *output;
    BReactor *reactor;
    PacketPassInactivityMonitor_handler handler;
    void *user;
    PacketPassInterface input;
    BTimer timer;
} PacketPassInactivityMonitor;

/**
 * Initializes the object.
 * See {@link PacketPassInactivityMonitor} for details.
 *
 * @param o the object
 * @param output output interface
 * @param reactor reactor we live in
 * @param interval timer value in milliseconds
 * @param handler handler function for reporting inactivity, or NULL to disable
 * @param user value passed to handler functions
 */
void PacketPassInactivityMonitor_Init (PacketPassInactivityMonitor *o, PacketPassInterface *output, BReactor *reactor, btime_t interval, PacketPassInactivityMonitor_handler handler, void *user);

/**
 * Frees the object.
 *
 * @param o the object
 */
void PacketPassInactivityMonitor_Free (PacketPassInactivityMonitor *o);

/**
 * Returns the input interface.
 * The MTU of the interface will be the same as of the output interface.
 * The interface supports cancel functionality if the output interface supports it.
 *
 * @param o the object
 * @return input interface
 */
PacketPassInterface * PacketPassInactivityMonitor_GetInput (PacketPassInactivityMonitor *o);

/**
 * Sets or removes the inactivity handler.
 *
 * @param o the object
 * @param handler handler function for reporting inactivity, or NULL to disable
 * @param user value passed to handler functions
 */
void PacketPassInactivityMonitor_SetHandler (PacketPassInactivityMonitor *o, PacketPassInactivityMonitor_handler handler, void *user);

/**
 * Sets the timer to expire immediately in order to force an inactivity report.
 * 
 * @param o the object
 */
void PacketPassInactivityMonitor_Force (PacketPassInactivityMonitor *o);

#endif
