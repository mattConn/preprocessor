# preprocessor
Pre-processor to be used in build tasks. I use it mostly for static site generation.

# Building
Requires flex scanner generator. `make` will build the preprocessor by first generating a scanner (lexer) with flex from `preprocessor.c`, then by compiling the generated `lex.yy.c` with a C compiler (currently clang, can be changed in makefile).

# Usage
`./preprocessor <file>` will send processed file contents to stdout.

# Supported Directives

## \#exec &lt;system command&gt;
Executes listed system command with `popen()` inline, sends to stdout.  
Example: ``#exec echo Page last edited: `date` `` 

## \#include &lt;directory&gt;
Like a C include. Directory must not be surrounded by quotation marks.  
Sends listed file contents to stdout via `cat` utility, executed with `popen()`.  
Example: `#include includes/footer.html`
