parser_201720857 :
	flex expression.l
	bison --debug -v -d grammar.y
	gcc -g -c -o generator.o generator.c
	gcc -g -c -o lex.yy.o lex.yy.c
	gcc -g -c -o grammar.tab.o grammar.tab.c
	gcc -g -o $@.out generator.o lex.yy.o grammar.tab.o -lfl

.PHONY : clean 
clean : 
	rm -rf *.tab.c *.tab.h *.yy.c *.out *.o *.tab.h.gch
