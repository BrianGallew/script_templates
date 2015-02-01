#include <assert.h>
#include <ctype.h>
#include <errno.h>
#include <fcntl.h>
#include <grp.h>
#include <inttypes.h>
#include <limits.h>
#include <pwd.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

/** 
*** May need these:
***	extern char *optarg;
***	extern int optind, opterr, optopt;
***
*** or this:
***	opterr = 0;	/* (in main) */
**/

/* Keep/remove leading colon as desired, or s/:/?/ */
static char OPTS[] = ":abcx:y:z:";
char	*Prog;

void	manpage		(void);
void	processArgs	(int, char *[]);
void	usage		(FILE *);

int main(int argc, char *argv[])
{
	/* Make the program name pretty */
	Prog = strrchr(argv[0], '/');
	if (Prog == NULL) {
		Prog = &argv[0][0];
	} else {
		++Prog;
	}

	/* Parse the command line */
	processArgs(argc, argv);
} /* main */

void manpage()
{
	return;
} /* manpage */

void processArgs(int argc, char *argv[])
{
	int  c;

	/* Special handling for --man */
	if ((argc > 1) && (strcmp(argv[1], "--man") == 0)) {
		manpage();
		exit(0);
	}

	while ((c = getopt(argc, argv, OPTS)) != -1) {
		switch (c) {
		case 'a':
			a = atoi(optarg);
			break;

		case ':':
			/* what goes here? */
			break;

		case '?':
			(void) fprintf(stderr,"bad arg: %c\n",optopt);
			usage(stderr);
			exit(1);

		default:
			usage(stderr);
			exit(1);
		}
	}

	return;
} /* processArgs */

void usage(FILE *stream)
{
	(void) fprintf(stream, "Usage: %s ...\n", Prog);
	return;
} /* Usage */
