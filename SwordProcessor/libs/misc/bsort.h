
#ifndef BADVPN_MISC_BSORT_H
#define BADVPN_MISC_BSORT_H

#include <stddef.h>
#include <stdint.h>
#include <string.h>

#include <misc/debug.h>
#include <misc/balloc.h>

typedef int (*BSort_comparator) (const void *e1, const void *e2);

static void BInsertionSort (void *arr, size_t count, size_t esize, BSort_comparator compatator, void *temp);

void BInsertionSort (void *arr, size_t count, size_t esize, BSort_comparator compatator, void *temp)
{
    ASSERT(esize > 0)
    
    for (size_t i = 0; i < count; i++) {
        size_t j = i;
        while (j > 0) {
            uint8_t *x = (uint8_t *)arr + (j - 1) * esize;
            uint8_t *y = (uint8_t *)arr + j * esize;
            int c = compatator(x, y);
            if (c <= 0) {
                break;
            }
            memcpy(temp, x, esize);
            memcpy(x, y, esize);
            memcpy(y, temp, esize);
            j--;
        }
    }
}

#endif
