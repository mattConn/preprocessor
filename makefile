COMPILER = clang-3.9

preprocessor: preprocessor.l
	flex $^; $(COMPILER) lex.yy.c -o $@; rm lex.yy.c

check:
	cd test; echo "\nORIGINAL---\n"; cat test.txt; echo "\nPROCESSED---\n"; ../preprocessor test.txt

clean:
	rm -r preprocessor
