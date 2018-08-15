
#ifndef BADVPN_BLIMITS_H
#define BADVPN_BLIMITS_H

#include <stdint.h>

#define BTYPE_IS_SIGNED(type) ((type)-1 < 0)

#define BSIGNED_TYPE_MIN(type) ( \
    sizeof(type) == 1 ? INT8_MIN : ( \
    sizeof(type) == 2 ? INT16_MIN : ( \
    sizeof(type) == 4 ? INT32_MIN : ( \
    sizeof(type) == 8 ? INT64_MIN : 0))))

#define BSIGNED_TYPE_MAX(type) ( \
    sizeof(type) == 1 ? INT8_MAX : ( \
    sizeof(type) == 2 ? INT16_MAX : ( \
    sizeof(type) == 4 ? INT32_MAX : ( \
    sizeof(type) == 8 ? INT64_MAX : 0))))

#define BUNSIGNED_TYPE_MIN(type) ((type)0)

#define BUNSIGNED_TYPE_MAX(type) ( \
    sizeof(type) == 1 ? UINT8_MAX : ( \
    sizeof(type) == 2 ? UINT16_MAX : ( \
    sizeof(type) == 4 ? UINT32_MAX : ( \
    sizeof(type) == 8 ? UINT64_MAX : 0))))

#define BTYPE_MIN(type) (BTYPE_IS_SIGNED(type) ? BSIGNED_TYPE_MIN(type) : BUNSIGNED_TYPE_MIN(type))
#define BTYPE_MAX(type) (BTYPE_IS_SIGNED(type) ? BSIGNED_TYPE_MAX(type) : BUNSIGNED_TYPE_MAX(type))

#endif
