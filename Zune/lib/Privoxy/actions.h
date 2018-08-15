#ifndef ACTIONS_H_INCLUDED
#define ACTIONS_H_INCLUDED
#define ACTIONS_H_VERSION ""

struct action_spec;
struct current_action_spec;
struct client_state;



/* This structure is used to hold user-defined aliases */
struct action_alias
{
   const char * name;
   struct action_spec action[1];
   struct action_alias * next;
};


extern jb_err get_actions (char *line,
                           struct action_alias * alias_list,
                           struct action_spec *cur_action);
extern void free_alias_list(struct action_alias *alias_list);

extern void init_action(struct action_spec *dest);
extern void free_action(struct action_spec *src);
extern jb_err merge_actions (struct action_spec *dest,
                             const struct action_spec *src);
extern int update_action_bits_for_tag(struct client_state *csp, const char *tag);
extern jb_err check_negative_tag_patterns(struct client_state *csp, unsigned int flag);
extern jb_err copy_action (struct action_spec *dest,
                           const struct action_spec *src);
extern char * actions_to_text     (const struct action_spec *action);
extern char * actions_to_html     (const struct client_state *csp,
                                   const struct action_spec *action);
extern void init_current_action     (struct current_action_spec *dest);
extern void free_current_action     (struct current_action_spec *src);
extern jb_err merge_current_action  (struct current_action_spec *dest,
                                     const struct action_spec *src);
extern char * current_action_to_html(const struct client_state *csp,
                                     const struct current_action_spec *action);
extern char * actions_to_line_of_text(const struct current_action_spec *action);

extern jb_err get_action_token(char **line, char **name, char **value);
extern void unload_actions_file(void *file_data);
extern int load_action_files(struct client_state *csp);

#ifdef FEATURE_GRACEFUL_TERMINATION
void unload_current_actions_file(void);
#endif


/* Revision control strings from this header and associated .c file */
extern const char actions_rcs[];
extern const char actions_h_rcs[];

#endif /* ndef ACTIONS_H_INCLUDED */

/*
  Local Variables:
  tab-width: 3
  end:
*/

