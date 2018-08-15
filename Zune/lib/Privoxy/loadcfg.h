#ifndef LOADCFG_H_INCLUDED
#define LOADCFG_H_INCLUDED
#define LOADCFG_H_VERSION ""

/* Don't need project.h, only this: */
struct configuration_spec;

/* Global variables */

#ifdef FEATURE_TOGGLE
/* Privoxy's toggle state */
extern int global_toggle_state;
#endif /* def FEATURE_TOGGLE */

extern const char *configfile;


/* The load_config function is now going to call:
 * init_proxy_args, so it will need argc and argv.
 * Since load_config will also be a signal handler,
 * we need to have these globally available.
 */
extern int Argc;
extern char * const * Argv;
extern short int MustReload;


extern struct configuration_spec * load_config(void);

#ifdef FEATURE_GRACEFUL_TERMINATION
void unload_current_config_file(void);
#endif

/* Revision control strings from this header and associated .c file */
extern const char loadcfg_rcs[];
extern const char loadcfg_h_rcs[];

#endif /* ndef LOADCFG_H_INCLUDED */

/*
  Local Variables:
  tab-width: 3
  end:
*/
