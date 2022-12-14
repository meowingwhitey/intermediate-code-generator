parser_201720857 : exp.l grammer.y
	flex exp.l
	bison -d grammer.y
	gcc -g -c -o parser.o parser.c
	gcc -g -c -o lex.yy.o lex.yy.c
	gcc -g -c -o grammer.tab.o grammer.tab.c
	gcc -g -o $@.out grammer.tab.o parser.o lex.yy.o -ly -lfl

.PHONY : clean 
clean : 
	rm -rf *.tab.c *.tab.h *.yy.c *.out *.o
