
#ifndef BADVPN_BSTRING_H
#define BADVPN_BSTRING_H

#include <misc/debug.h>

#include <stdlib.h>
#include <string.h>

#define BSTRING_TYPE_STATIC 5
#define BSTRING_TYPE_DYNAMIC 7
#define BSTRING_TYPE_EXTERNAL 11

#define BSTRING_STATIC_SIZE 23
#define BSTRING_STATIC_MAX (BSTRING_STATIC_SIZE - 1)

typedef struct {
    union {
        struct {
            char type;
            char static_string[BSTRING_STATIC_SIZE];
        } us;
        struct {
            char type;
            char *dynamic_string;
        } ud;
        struct {
            char type;
            const char *external_string;
        } ue;
    } u;
} BString;

static void BString__assert (BString *o)
{
    switch (o->u.us.type) {
        case BSTRING_TYPE_STATIC:
        case BSTRING_TYPE_DYNAMIC:
        case BSTRING_TYPE_EXTERNAL:
            return;
    }
    
    ASSERT(0);
}

static int BString_Init (BString *o, const char *str)
{
    if (strlen(str) <= BSTRING_STATIC_MAX) {
        strcpy(o->u.us.static_string, str);
        o->u.us.type = BSTRING_TYPE_STATIC;
    } else {
        if (!(o->u.ud.dynamic_string = malloc(strlen(str) + 1))) {
            return 0;
        }
        strcpy(o->u.ud.dynamic_string, str);
        o->u.ud.type = BSTRING_TYPE_DYNAMIC;
    }
    
    BString__assert(o);
    return 1;
}

static void BString_InitStatic (BString *o, const char *str)
{
    ASSERT(strlen(str) <= BSTRING_STATIC_MAX)
    
    strcpy(o->u.us.static_string, str);
    o->u.us.type = BSTRING_TYPE_STATIC;
    
    BString__assert(o);
}

static void BString_InitExternal (BString *o, const char *str)
{
    o->u.ue.external_string = str;
    o->u.ue.type = BSTRING_TYPE_EXTERNAL;
    
    BString__assert(o);
}

static void BString_InitAllocated (BString *o, char *str)
{
    o->u.ud.dynamic_string = str;
    o->u.ud.type = BSTRING_TYPE_DYNAMIC;
    
    BString__assert(o);
}

static void BString_Free (BString *o)
{
    BString__assert(o);
    
    if (o->u.ud.type == BSTRING_TYPE_DYNAMIC) {
        free(o->u.ud.dynamic_string);
    }
}

static const char * BString_Get (BString *o)
{
    BString__assert(o);
    
    switch (o->u.us.type) {
        case BSTRING_TYPE_STATIC: return o->u.us.static_string;
        case BSTRING_TYPE_DYNAMIC: return o->u.ud.dynamic_string;
        case BSTRING_TYPE_EXTERNAL: return o->u.ue.external_string;
    }
    
    ASSERT(0);
    return NULL;
}

#endif
