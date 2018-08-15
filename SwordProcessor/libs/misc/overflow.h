
#ifndef BADVPN_MISC_OVERFLOW_H
#define BADVPN_MISC_OVERFLOW_H

#include <limits.h>
#include <stdint.h>

#define DEFINE_UNSIGNED_OVERFLOW(_name, _type, _max) \
static int add_ ## _name ## _overflows (_type a, _type b) \
{\
    return (b > _max - a); \
}

#define DEFINE_SIGNED_OVERFLOW(_name, _type, _min, _max) \
static int add_ ## _name ## _overflows (_type a, _type b) \
{\
    if ((a < 0) ^ (b < 0)) return 0; \
    if (a < 0) return -(a < _min - b); \
    return (a > _max - b); \
}

DEFINE_UNSIGNED_OVERFLOW(uint, unsigned int, UINT_MAX)
DEFINE_UNSIGNED_OVERFLOW(uint8, uint8_t, UINT8_MAX)
DEFINE_UNSIGNED_OVERFLOW(uint16, uint16_t, UINT16_MAX)
DEFINE_UNSIGNED_OVERFLOW(uint32, uint32_t, UINT32_MAX)
DEFINE_UNSIGNED_OVERFLOW(uint64, uint64_t, UINT64_MAX)

DEFINE_SIGNED_OVERFLOW(int, int, INT_MIN, INT_MAX)
DEFINE_SIGNED_OVERFLOW(int8, int8_t, INT8_MIN, INT8_MAX)
DEFINE_SIGNED_OVERFLOW(int16, int16_t, INT16_MIN, INT16_MAX)
DEFINE_SIGNED_OVERFLOW(int32, int32_t, INT32_MIN, INT32_MAX)
DEFINE_SIGNED_OVERFLOW(int64, int64_t, INT64_MIN, INT64_MAX)

#endif
