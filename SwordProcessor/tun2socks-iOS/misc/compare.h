
#ifndef BADVPN_COMPARE_H
#define BADVPN_COMPARE_H

#define B_COMPARE(a, b) (((a) > (b)) - ((a) < (b)))
#define B_COMPARE_COMBINE(cmp1, cmp2) ((cmp1) ? (cmp1) : (cmp2))
#define B_COMPARE2(a, b, c, d) B_COMPARE_COMBINE(B_COMPARE((a), (b)), B_COMPARE((c), (d)))

#endif
