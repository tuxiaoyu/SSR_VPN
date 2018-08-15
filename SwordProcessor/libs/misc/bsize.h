
#ifndef BADVPN_MISC_BSIZE_H
#define BADVPN_MISC_BSIZE_H

#include <stddef.h>
#include <limits.h>
#include <stdint.h>

typedef struct {
    int is_overflow;
    size_t value;
} bsize_t;

static bsize_t bsize_fromsize (size_t v);
static bsize_t bsize_fromint (int v);
static bsize_t bsize_overflow (void);
static int bsize_tosize (bsize_t s, size_t *out);
static int bsize_toint (bsize_t s, int *out);
static bsize_t bsize_add (bsize_t s1, bsize_t s2);
static bsize_t bsize_max (bsize_t s1, bsize_t s2);
static bsize_t bsize_mul (bsize_t s1, bsize_t s2);

bsize_t bsize_fromsize (size_t v)
{
    bsize_t s = {0, v};
    return s;
}

bsize_t bsize_fromint (int v)
{
    bsize_t s = {(v < 0 || v > SIZE_MAX), v};
    return s;
}

static bsize_t bsize_overflow (void)
{
    bsize_t s = {1, 0};
    return s;
}

int bsize_tosize (bsize_t s, size_t *out)
{
    if (s.is_overflow) {
        return 0;
    }
    
    if (out) {
        *out = s.value;
    }
    
    return 1;
}

int bsize_toint (bsize_t s, int *out)
{
    if (s.is_overflow || s.value > INT_MAX) {
        return 0;
    }
    
    if (out) {
        *out = (int)s.value;
    }
    
    return 1;
}

bsize_t bsize_add (bsize_t s1, bsize_t s2)
{
    bsize_t s = {(s1.is_overflow || s2.is_overflow || s2.value > SIZE_MAX - s1.value), (s1.value + s2.value)};
    return s;
}

bsize_t bsize_max (bsize_t s1, bsize_t s2)
{
    bsize_t s = {(s1.is_overflow || s2.is_overflow), ((s1.value > s2.value) * s1.value + (s1.value <= s2.value) * s2.value)};
    return s;
}

bsize_t bsize_mul (bsize_t s1, bsize_t s2)
{
    bsize_t s = {(s1.is_overflow || s2.is_overflow || (s1.value != 0 && s2.value > SIZE_MAX / s1.value)), (s1.value * s2.value)};
    return s;
}

#endif
