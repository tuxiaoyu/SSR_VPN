
#ifndef BADVPN_MISC_BALIGN_H
#define BADVPN_MISC_BALIGN_H

#include <stddef.h>
#include <stdint.h>

/**
 * Checks if aligning x up to n would overflow.
 */
static int balign_up_overflows (size_t x, size_t n)
{
    size_t r = x % n;
    
    return (r && x > SIZE_MAX - (n - r));
}

/**
 * Aligns x up to n.
 */
static size_t balign_up (size_t x, size_t n)
{
    size_t r = x % n;
    return (r ? x + (n - r) : x);
}

/**
 * Aligns x down to n.
 */
static size_t balign_down (size_t x, size_t n)
{
    return (x - (x % n));
}

/**
 * Calculates the quotient of a and b, rounded up.
 */
static size_t bdivide_up (size_t a, size_t b)
{
    size_t r = a % b;
    return (r > 0 ? a / b + 1 : a / b);
}

#endif
