
#ifndef BADVPN_FLOW_BUFFERWRITER_H
#define BADVPN_FLOW_BUFFERWRITER_H

#include <stdint.h>

#include "misc/debug.h"
#include "base/DebugObject.h"
#include "flow/PacketRecvInterface.h"

/**
 * Object for writing packets to a {@link PacketRecvInterface} client
 * in a best-effort fashion.
 */
typedef struct {
    PacketRecvInterface recv_interface;
    int out_have;
    uint8_t *out;
    DebugObject d_obj;
    #ifndef NDEBUG
    int d_mtu;
    int d_writing;
    #endif
} BufferWriter;

/**
 * Initializes the object.
 * The object is initialized in not writing state.
 *
 * @param o the object
 * @param mtu maximum input packet length
 * @param pg pending group
 */
void BufferWriter_Init (BufferWriter *o, int mtu, BPendingGroup *pg);

/**
 * Frees the object.
 *
 * @param o the object
 */
void BufferWriter_Free (BufferWriter *o);

/**
 * Returns the output interface.
 *
 * @param o the object
 * @return output interface
 */
PacketRecvInterface * BufferWriter_GetOutput (BufferWriter *o);

/**
 * Attempts to provide a memory location for writing a packet.
 * The object must be in not writing state.
 * On success, the object enters writing state.
 * 
 * @param o the object
 * @param buf if not NULL, on success, the memory location will be stored here.
 *            It will have space for MTU bytes.
 * @return 1 on success, 0 on failure
 */
int BufferWriter_StartPacket (BufferWriter *o, uint8_t **buf) WARN_UNUSED;

/**
 * Submits a packet written to the buffer.
 * The object must be in writing state.
 * Yhe object enters not writing state.
 * 
 * @param o the object
 * @param len length of the packet that was written. Must be >=0 and
 *            <=MTU.
 */
void BufferWriter_EndPacket (BufferWriter *o, int len);

#endif
