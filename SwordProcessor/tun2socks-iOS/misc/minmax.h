
#ifndef BADVPN_MISC_MINMAX_H
#define BADVPN_MISC_MINMAX_H

#include <stddef.h>
#include <stdint.h>

#define DEFINE_BMINMAX(name, type) \
static type bmin ## name (type a, type b) { return (a < b ? a : b); } \
static type bmax ## name (type a, type b) { return (a > b ? a : b); }

DEFINE_BMINMAX(_size, size_t)
DEFINE_BMINMAX(_int, int)
DEFINE_BMINMAX(_int8, int8_t)
DEFINE_BMINMAX(_int16, int16_t)
DEFINE_BMINMAX(_int32, int32_t)
DEFINE_BMINMAX(_int64, int64_t)
DEFINE_BMINMAX(_uint, unsigned int)
DEFINE_BMINMAX(_uint8, uint8_t)
DEFINE_BMINMAX(_uint16, uint16_t)
DEFINE_BMINMAX(_uint32, uint32_t)
DEFINE_BMINMAX(_uint64, uint64_t)

#endif
