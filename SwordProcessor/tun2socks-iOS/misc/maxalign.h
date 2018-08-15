
#ifndef BADVPN_MAXALIGN_H
#define BADVPN_MAXALIGN_H

#include <stddef.h>
#include <stdint.h>

typedef union {
    short a;
    long b;
    long long c;
    double d;
    long double e;
    void *f;
    uint8_t g;
    uint16_t h;
    uint32_t i;
    uint64_t j;
    size_t k;
    void (*l) (void);
} bmax_align_t;

#define BMAX_ALIGN (__alignof(bmax_align_t))

#endif
