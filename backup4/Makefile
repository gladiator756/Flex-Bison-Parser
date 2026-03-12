all:
	bison -d parser.y
	flex lexer.l
	gcc parser.tab.c lex.yy.c -o myParser.exe

clean:
	rm -f lex.yy.c parser.tab.c parser.tab.h myParser.exe