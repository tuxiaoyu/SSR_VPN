
#ifndef BADVPN_MISC_EXPARRAY_H
#define BADVPN_MISC_EXPARRAY_H

#include <stddef.h>
#include <stdlib.h>
#include <limits.h>

#include <misc/debug.h>

struct ExpArray {
    size_t esize;
    size_t size;
    void *v;
};

static int ExpArray_init (struct ExpArray *o, size_t esize, size_t size)
{
    ASSERT(esize > 0)
    ASSERT(size > 0)
    
    o->esize = esize;
    o->size = size;
    
    if (o->size > SIZE_MAX / o->esize) {
        return 0;
    }
    
    if (!(o->v = malloc(o->size * o->esize))) {
        return 0;
    }
    
    return 1;
}

static int ExpArray_resize (struct ExpArray *o, size_t size)
{
    ASSERT(size > 0)
    
    if (size <= o->size) {
        return 1;
    }
    
    size_t newsize = o->size;
    
    while (newsize < size) {
        if (2 > SIZE_MAX / newsize) {
            return 0;
        }
        
        newsize = 2 * newsize;
    }
    
    if (newsize > SIZE_MAX / o->esize) {
        return 0;
    }
    
    void *newarr = realloc(o->v, newsize * o->esize);
    if (!newarr) {
        return 0;
    }
    
    o->size = newsize;
    o->v = newarr;
    
    return 1;
}

#endif
