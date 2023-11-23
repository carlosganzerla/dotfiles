//Modify this file to change what commands output to your statusbar, and recompile using the make command.
static const Block blocks[] = {
	/*Icon*/	/*Command*/		/*Update Interval*/	/*Update Signal*/

	{"",	"sb-internet",	5,	4},
	{"",	"sb-pacpackages",	0,	8},
	{"",	"sb-disk",	0,	9},
	{"",	"sb-nettraf",	1,	16},
	{"",	"sb-cpu",	10,	18},
	{"",	"sb-volume",	1,	10},
	{"",	"sb-battery",	5,	3},

	{" ", "date '+%a %d/%m %H:%M'",					5,		0},
};

//sets delimeter between status commands. NULL character ('\0') means no delimeter.
static char delim[] = " ";
static unsigned int delimLen = 5;
