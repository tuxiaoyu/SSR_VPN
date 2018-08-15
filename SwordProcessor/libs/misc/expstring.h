
#ifndef BADVPN_MISC_EXPSTRING_H
#define BADVPN_MISC_EXPSTRING_H

#include <stddef.h>

#include <misc/debug.h>
#include <misc/exparray.h>
#include <misc/bsize.h>
#include <misc/memref.h>

typedef struct {
    struct ExpArray arr;
    size_t n;
} ExpString;

static int ExpString_Init (ExpString *c);
static void ExpString_Free (ExpString *c);
static int ExpString_Append (ExpString *c, const char *str);
static int ExpString_AppendChar (ExpString *c, char ch);
static int ExpString_AppendByte (ExpString *c, uint8_t x);
static int ExpString_AppendBinary (ExpString *c, const uint8_t *data, size_t len);
static int ExpString_AppendBinaryMr (ExpString *c, MemRef data);
static int ExpString_AppendZeros (ExpString *c, size_t len);
static char * ExpString_Get (ExpString *c);
static size_t ExpString_Length (ExpString *c);
static MemRef ExpString_GetMr (ExpString *c);

int ExpString_Init (ExpString *c)
{
    if (!ExpArray_init(&c->arr, 1, 16)) {
        return 0;
    }
    
    c->n = 0;
    ((char *)c->arr.v)[c->n] = '\0';
    
    return 1;
}

void ExpString_Free (ExpString *c)
{
    free(c->arr.v);
}

int ExpString_Append (ExpString *c, const char *str)
{
    ASSERT(str)
    
    size_t l = strlen(str);
    bsize_t newsize = bsize_add(bsize_fromsize(c->n), bsize_add(bsize_fromsize(l), bsize_fromint(1)));
    
    if (newsize.is_overflow || !ExpArray_resize(&c->arr, newsize.value)) {
        return 0;
    }
    
    memcpy((char *)c->arr.v + c->n, str, l);
    c->n += l;
    ((char *)c->arr.v)[c->n] = '\0';
    
    return 1;
}

int ExpString_AppendChar (ExpString *c, char ch)
{
    ASSERT(ch != '\0')
    
    bsize_t newsize = bsize_add(bsize_fromsize(c->n), bsize_fromint(2));
    
    if (newsize.is_overflow || !ExpArray_resize(&c->arr, newsize.value)) {
        return 0;
    }
    
    ((char *)c->arr.v)[c->n] = ch;
    c->n++;
    ((char *)c->arr.v)[c->n] = '\0';
    
    return 1;
}

int ExpString_AppendByte (ExpString *c, uint8_t x)
{
    bsize_t newsize = bsize_add(bsize_fromsize(c->n), bsize_fromint(2));
    
    if (newsize.is_overflow || !ExpArray_resize(&c->arr, newsize.value)) {
        return 0;
    }
    
    ((uint8_t *)c->arr.v)[c->n] = x;
    c->n++;
    ((char *)c->arr.v)[c->n] = '\0';
    
    return 1;
}

int ExpString_AppendBinary (ExpString *c, const uint8_t *data, size_t len)
{
    bsize_t newsize = bsize_add(bsize_fromsize(c->n), bsize_add(bsize_fromsize(len), bsize_fromint(1)));
    
    if (newsize.is_overflow || !ExpArray_resize(&c->arr, newsize.value)) {
        return 0;
    }
    
    memcpy((char *)c->arr.v + c->n, data, len);
    c->n += len;
    ((char *)c->arr.v)[c->n] = '\0';
    
    return 1;
}

int ExpString_AppendBinaryMr (ExpString *c, MemRef data)
{
    return ExpString_AppendBinary(c, (uint8_t const *)data.ptr, data.len);
}

int ExpString_AppendZeros (ExpString *c, size_t len)
{
    bsize_t newsize = bsize_add(bsize_fromsize(c->n), bsize_add(bsize_fromsize(len), bsize_fromint(1)));
    
    if (newsize.is_overflow || !ExpArray_resize(&c->arr, newsize.value)) {
        return 0;
    }
    
    memset((char *)c->arr.v + c->n, 0, len);
    c->n += len;
    ((char *)c->arr.v)[c->n] = '\0';
    
    return 1;
}

char * ExpString_Get (ExpString *c)
{
    return (char *)c->arr.v;
}

size_t ExpString_Length (ExpString *c)
{
    return c->n;
}

MemRef ExpString_GetMr (ExpString *c)
{
    return MemRef_Make((char const *)c->arr.v, c->n);
}

#endif
