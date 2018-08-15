
#ifndef BADVPN_MISC_DEAD_H
#define BADVPN_MISC_DEAD_H

#include <stdlib.h>

/**
 * Dead variable.
 */
typedef int *dead_t;

/**
 * Initializes a dead variable.
 */
#define DEAD_INIT(ptr) { ptr = NULL; }

/**
 * Kills the dead variable,
 */
#define DEAD_KILL(ptr) { if (ptr) *(ptr) = 1; }

/**
 * Kills the dead variable with the given value, or does nothing
 * if the value is 0. The value will seen by {@link DEAD_KILLED}.
 */
#define DEAD_KILL_WITH(ptr, val) { if (ptr) *(ptr) = (val); }

/**
 * Declares dead catching variables.
 */
#define DEAD_DECLARE int badvpn__dead; dead_t badvpn__prev_ptr;

/**
 * Enters a dead catching using already declared dead catching variables.
 * The dead variable must have been initialized with {@link DEAD_INIT},
 * and {@link DEAD_KILL} must not have been called yet.
 * {@link DEAD_LEAVE2} must be called before the current scope is left.
 */
#define DEAD_ENTER2(ptr) { badvpn__dead = 0; badvpn__prev_ptr = ptr; ptr = &badvpn__dead; }

/**
 * Declares dead catching variables and enters a dead catching.
 * The dead variable must have been initialized with {@link DEAD_INIT},
 * and {@link DEAD_KILL} must not have been called yet.
 * {@link DEAD_LEAVE2} must be called before the current scope is left.
 */
#define DEAD_ENTER(ptr) DEAD_DECLARE DEAD_ENTER2(ptr)

/**
 * Leaves a dead catching.
 */
#define DEAD_LEAVE2(ptr) { if (!badvpn__dead) ptr = badvpn__prev_ptr; if (badvpn__prev_ptr) *badvpn__prev_ptr = badvpn__dead; }

/**
 * Returns 1 if {@link DEAD_KILL} was called for the dead variable, 0 otherwise.
 * Must be called after entering a dead catching.
 */
#define DEAD_KILLED (badvpn__dead)

#define DEAD_DECLARE_N(n) int badvpn__dead##n; dead_t badvpn__prev_ptr##n;
#define DEAD_ENTER2_N(n, ptr) { badvpn__dead##n = 0; badvpn__prev_ptr##n = ptr; ptr = &badvpn__dead##n;}
#define DEAD_ENTER_N(n, ptr) DEAD_DECLARE_N(n) DEAD_ENTER2_N(n, ptr)
#define DEAD_LEAVE2_N(n, ptr) { if (!badvpn__dead##n) ptr = badvpn__prev_ptr##n; if (badvpn__prev_ptr##n) *badvpn__prev_ptr##n = badvpn__dead##n; }
#define DEAD_KILLED_N(n) (badvpn__dead##n)

#endif
