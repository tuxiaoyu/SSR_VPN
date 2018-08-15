
#ifndef BADVPN_MISC_OFFSET_H
#define BADVPN_MISC_OFFSET_H

#include <stddef.h>
#include <stdint.h>

/**
 * Returns a pointer to a struct, given a pointer to its member.
 */
#define UPPER_OBJECT(_ptr, _object_type, _field_name) ((_object_type *)((char *)(_ptr) - offsetof(_object_type, _field_name)))

/**
 * Returns the offset of one struct member from another.
 * Expands to an int.
 */
#define OFFSET_DIFF(_object_type, _field1, _field2) ((int)offsetof(_object_type, _field1) - (int)offsetof(_object_type, _field2))

#endif
