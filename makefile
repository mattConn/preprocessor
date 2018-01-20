COMPILER = 'clang-3.9'

preprocessor: preprocessor.l
	flex $^; $(COMPILER) lex.yy.c -o $@; rm lex.yy.c

clean:
	rm preprocessor
