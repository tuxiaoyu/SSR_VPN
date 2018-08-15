
#ifndef BADVPN_MISC_MODADD_H
#define BADVPN_MISC_MODADD_H

#include <misc/debug.h>

#define DECLARE_BMODADD(type, name) \
static type bmodadd_##name (type x, type y, type m) \
{ \
    ASSERT(x >= 0) \
    ASSERT(x < m) \
    ASSERT(y >= 0) \
    ASSERT(y < m) \
     \
    if (y >= m - x) { \
        return (y - (m - x)); \
    } else { \
        return (x + y); \
    } \
} \

DECLARE_BMODADD(int, int)

#endif
