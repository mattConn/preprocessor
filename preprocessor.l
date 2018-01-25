%option noyywrap
%{
#include <stdio.h>
#include <stdbool.h>
#define SIZE 50

bool directive = false; // if reading text after directive
char directiveType[SIZE]; // type of directive
char directiveArg[SIZE]; // argument for preprocessor, comes after directive (file to open, command to exec, etc.)
char command[SIZE];
int status = 0; // system command status

int linecount = 0; // line count

%}

%%

. {
	if(directive)
		strcat(directiveArg, yytext);
	else
		printf("%s", yytext);
}

^"#include " {
	directive = true;
	strcpy(directiveType, "include");
}

^"#exec " {
	directive = true;
	strcpy(directiveType, "exec");
}

\n {

	linecount++;

	if(directive)
	{
		if(strcmp(directiveType, "include") == 0) // C includes
			strcpy(command, "cat ");

		// concat command and directiveArg for system call
		strcat(command, directiveArg);

		FILE *execCommand = popen(command, "r");
		char stdoutStr[SIZE]; // for storing and printing execCommand stdout
		while (fgets(stdoutStr, sizeof(stdoutStr), execCommand) != NULL) 
      		printf("%s", stdoutStr);

		pclose(execCommand);

		// reset condition, variables
		directive = false;
		directiveArg[0] = command[0] = stdoutStr[0] = directiveType[0] = '\0';

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
