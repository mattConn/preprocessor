%option noyywrap
%{
#include <stdio.h>
#include <stdbool.h>
#define SIZE 50

bool directive = false;
char directory[SIZE];
char command[] = {"cat "}; // system command
int status = 0; // system command status
char tmp[SIZE + sizeof(command)/sizeof(command[0])];

int linecount = 0; // line count

%}

%%

. {
	if(directive)
		strcat(directory, yytext);
	else
		printf("%s", yytext);
}

^"#include " { directive = true; }

\n {

	linecount++;

	if(directive)
	{
		// concat command and directory for system call
		strcat(tmp, command);
		strcat(tmp, directory);

		system(tmp);

		// reset condition, variables
		directive = false;
		directory[0] = tmp[0] = '\0';
	}
	else
		printf("%s", yytext);
}

%%

int main(int argc, char *argv[])
{
    FILE *file;
    file = fopen(argv[1], "r");

    yyset_in(file);
    yylex();
    fclose(file);
}
