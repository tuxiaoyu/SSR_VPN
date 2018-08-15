#ifndef DEANIMATE_H_INCLUDED
#define DEANIMATE_H_INCLUDED
#define DEANIMATE_H_VERSION ""

/*
 * A struct that holds a buffer, a read/write offset,
 * and the buffer's capacity.
 */
struct binbuffer
{
   char *buffer;
   size_t offset;
   size_t size;
};

/*
 * Function prototypes
 */
extern int gif_deanimate(struct binbuffer *src, struct binbuffer *dst, int get_first_image);
extern void binbuf_free(struct binbuffer *buf);

/*
 * Revision control strings from this header and associated .c file
 */
extern const char deanimate_rcs[];
extern const char deanimate_h_rcs[];

#endif /* ndef DEANIMATE_H_INCLUDED */

/*
  Local Variables:
  tab-width: 3
  end:
*/
