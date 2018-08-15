
#ifndef BADVPN_UTF16DECODER_H
#define BADVPN_UTF16DECODER_H

#include <stdint.h>

#include <misc/debug.h>

/**
 * Decodes UTF-16 data into Unicode characters.
 */
typedef struct {
    int cont;
    uint32_t ch;
} Utf16Decoder;

/**
 * Initializes the UTF-16 decoder.
 * 
 * @param o the object
 */
static void Utf16Decoder_Init (Utf16Decoder *o);

/**
 * Inputs a 16-bit value to the decoder.
 * 
 * @param o the object
 * @param b 16-bit value to input
 * @param out_ch will receive a Unicode character if this function returns 1.
 *               If written, the character will be in the range 0 - 0x10FFFF,
 *               excluding the surrogate range 0xD800 - 0xDFFF.
 * @return 1 if a Unicode character has been written to *out_ch, 0 if not
 */
static int Utf16Decoder_Input (Utf16Decoder *o, uint16_t b, uint32_t *out_ch);

void Utf16Decoder_Init (Utf16Decoder *o)
{
    o->cont = 0;
}

int Utf16Decoder_Input (Utf16Decoder *o, uint16_t b, uint32_t *out_ch)
{
    // high surrogate
    if (b >= UINT16_C(0xD800) && b <= UINT16_C(0xDBFF)) {
        // set continuation state
        o->cont = 1;
        
        // add high bits
        o->ch = (uint32_t)(b - UINT16_C(0xD800)) << 10;
        
        return 0;
    }
    
    // low surrogate
    if (b >= UINT16_C(0xDC00) && b <= UINT16_C(0xDFFF)) {
        // check continuation
        if (!o->cont) {
            return 0;
        }
        
        // add low bits
        o->ch |= (b - UINT16_C(0xDC00));
        
        // reset state
        o->cont = 0;
        
        // don't report surrogates
        if (o->ch >= UINT32_C(0xD800) && o->ch <= UINT32_C(0xDFFF)) {
            return 0;
        }
        
        // return character
        *out_ch = o->ch;
        return 1;
    }
    
    // reset state
    o->cont = 0;
    
    // return character
    *out_ch = b;
    return 1;
}

#endif
