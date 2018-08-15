
/**
 * @def DEBUG
 * 
 * Macro for printing debugging text. Use the same way as printf,
 * but without a newline.
 * Prepends "function_name: " and appends a newline.
 */

/**
 * @def ASSERT_FORCE
 * 
 * Macro for forced assertions.
 * Evaluates the argument and terminates the program abnormally
 * if the result is false.
 */

/**
 * @def ASSERT
 * 
 * Macro for assertions.
 * The argument may or may not be evaluated.
 * If the argument is evaluated, it must not evaluate to false.
 */

/**
 * @def ASSERT_EXECUTE
 * 
 * Macro for always-evaluated assertions.
 * The argument is evaluated.
 * The argument must not evaluate to false.
 */

/**
 * @def DEBUG_ZERO_MEMORY
 * 
 * If debugging is enabled, zeroes the given memory region.
 * First argument is pointer to the memory region, second is
 * number of bytes.
 */

/**
 * @def WARN_UNUSED
 * 
 * Tells the compiler that the result of a function should not be unused.
 * Insert at the end of the declaration of a function before the semicolon.
 */

/**
 * @def B_USE
 * 
 * This can be used to suppress warnings about unused variables. It can
 * be applied to a variable or any expression. It does not evaluate the
 * expression.
 */

#ifndef BADVPN_MISC_DEBUG_H
#define BADVPN_MISC_DEBUG_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <assert.h>

#define DEBUG(...) \
    { \
        fprintf(stderr, "%s: ", __FUNCTION__); \
        fprintf(stderr, __VA_ARGS__); \
        fprintf(stderr, "\n"); \
    }

#define ASSERT_FORCE(e) \
    { \
        if (!(e)) { \
            fprintf(stderr, "%s:%d Assertion failed\n", __FILE__, __LINE__); \
        } \
    }

#ifdef NDEBUG
    #define DEBUG_ZERO_MEMORY(buf, len) {}
    #define ASSERT(e) {}
    #define ASSERT_EXECUTE(e) { (e); }
#else
    #define DEBUG_ZERO_MEMORY(buf, len) { memset((buf), 0, (len)); }
    #ifdef BADVPN_USE_C_ASSERT
        #define ASSERT(e) { assert(e); }
        #define ASSERT_EXECUTE(e) \
            { \
                int _assert_res = !!(e); \
                assert(_assert_res); \
            }
    #else
        #define ASSERT(e) ASSERT_FORCE(e)
        #define ASSERT_EXECUTE(e) ASSERT_FORCE(e)
    #endif
#endif

#ifdef __GNUC__
    #define WARN_UNUSED __attribute__((warn_unused_result))
#else
    #define WARN_UNUSED
#endif

#define B_USE(expr) (void)(sizeof((expr)));

#define B_ASSERT_USE(expr) { ASSERT(expr) B_USE(expr) }

#endif