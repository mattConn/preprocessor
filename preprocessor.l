%option noyywrap
%{
#include <stdio.h>
#include <stdbool.h>
#define SIZE 50

bool directive = false; // if reading text after directive
char directory[SIZE]; // file to open
char command[] = {"cat "};
int status = 0; // system command status
char tmpCommand[SIZE + sizeof(command)/sizeof(command[0])]; // system command + file name

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
		strcat(tmpCommand, command);
		strcat(tmpCommand, directory);

		FILE *execCommand = popen(tmpCommand, "r");
		char stdoutStr[SIZE];
		while (fgets(stdoutStr, sizeof(stdoutStr), execCommand) != NULL) 
      		printf("%s", stdoutStr);

		pclose(execCommand);

		// reset condition, variables
		directive = false;
		directory[0] = tmpCommand[0] = stdoutStr[0] = '\0';

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

	return 0;
}
