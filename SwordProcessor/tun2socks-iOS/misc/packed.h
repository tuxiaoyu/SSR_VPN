
#ifndef BADVPN_PACKED_H
#define BADVPN_PACKED_H

#ifdef _MSC_VER

#define B_START_PACKED __pragma(pack(push, 1))
#define B_END_PACKED __pragma(pack(pop))
#define B_PACKED

#else

#define B_START_PACKED
#define B_END_PACKED
#define B_PACKED __attribute__((packed))

#endif

#endif
