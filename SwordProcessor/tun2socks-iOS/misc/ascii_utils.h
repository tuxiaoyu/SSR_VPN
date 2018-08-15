
#ifndef BADVPN_ASCII_UTILS_H
#define BADVPN_ASCII_UTILS_H

static char b_ascii_tolower (char c)
{
    return (c >= 'A' && c <= 'Z') ? (c + 32) : c;
}

static char b_ascii_toupper (char c)
{
    return (c >= 'a' && c <= 'z') ? (c - 32) : c;
}

#endif
