#ifndef LIST_H_INCLUDED
#define LIST_H_INCLUDED
#define LIST_H_VERSION ""

#include "Earth.h"

/*
 * struct list
 *
 * A linked list class.
 */

extern void init_list    (struct list *the_list);
extern void destroy_list (struct list *the_list);

extern jb_err enlist                 (struct list *the_list, const char *str);
extern jb_err enlist_unique          (struct list *the_list, const char *str, size_t num_significant_chars);
extern jb_err enlist_unique_header   (struct list *the_list, const char *name, const char *value);
extern jb_err enlist_first           (struct list *the_list, const char *str);
extern jb_err list_append_list_unique(struct list *dest,     const struct list *src);
extern jb_err list_duplicate         (struct list *dest,     const struct list *src);

extern int    list_remove_item(struct list *the_list, const char *str);
extern int    list_remove_list(struct list *dest,     const struct list *src);
extern void   list_remove_all (struct list *the_list);

extern int    list_is_empty(const struct list *the_list);

extern char * list_to_text(const struct list *the_list);

extern int    list_contains_item(const struct list *the_list, const char *str);

/*
 * struct map
 *
 * A class which maps names to values.
 *
 * Note: You must allocate this through new_map() and free it
 * through free_map().
 */

extern struct map * new_map  (void);
extern void         free_map (struct map * the_map);

extern jb_err       map      (struct map * the_map,
                              const char * name, int name_needs_copying,
                              const char * value, int value_needs_copying);
extern jb_err       unmap    (struct map *the_map,
                              const char *name);
extern const char * lookup   (const struct map * the_map, const char * name);


/* Revision control strings from this header and associated .c file */
extern const char list_rcs[];
extern const char list_h_rcs[];

#endif /* ndef LIST_H_INCLUDED */

/*
  Local Variables:
  tab-width: 3
  end:
*/
