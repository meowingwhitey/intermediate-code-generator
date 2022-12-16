%{
  #include "generator.h"
  #include "grammar.tab.h"
  extern int error_position;
  extern int lexical_error;
  extern void yyerror();
%}
%option yylineno
%%
"+" { /* ADD */ error_position += strlen(yytext); return ADD; }
"-" { /* SUB */ error_position += strlen(yytext); return SUB; }
"*" { /* MUL */ error_position += strlen(yytext); return MUL; }
"/" { /* DIV */ error_position += strlen(yytext); return DIV; }
"=" { /* ASSIGN */ error_position += strlen(yytext); return ASSIGN; }
"(" { /* LP */ error_position += strlen(yytext); return LP; }
")" { /* RP */ error_position += strlen(yytext); return RP; }
"," { /* COMMA */ error_position += strlen(yytext); return COMMA; }
";" { error_position += strlen(yytext); return SEMI_COLON; }
[0-9]*[.][0-9]+ { 
  /* DOUBLE */ 
  yylval.attr[0] = (char*)malloc(sizeof(yytext) + 1);
  strcpy(yylval.attr[0], yytext);
  yylval.attr[1] = DOUBLE;
  error_position += strlen(yytext);
  return DOUBLE; 
}
0|[1-9][0-9]* { 
  /* INTEGER */ 
  yylval.attr[0] = (char*)malloc(sizeof(yytext) + 1);
  strcpy(yylval.attr[0], yytext);
  yylval.attr[1] = INTEGER;
  error_position += strlen(yytext);
  return INTEGER; 
}
[A-Za-z]+[A-Za-z0-9]* { 
  /* ID */ 
  yylval.attr[0] = (char*)malloc(sizeof(yytext) + 1);
  strcpy(yylval.attr[0], yytext);
  yylval.attr[1] = ID;
  error_position += strlen(yytext);
  return ID; 
}
"int" { error_position += strlen(yytext); return INTEGER_DECLARE; }
"double" { error_position += strlen(yytext); return DOUBLE_DECLARE; }
<<EOF>> { exit(EXIT_SUCCESS); }
"\n" { error_position = 0; };
[ \t] { error_position += strlen(yytext); };
. { 
  printf("Lexical Error in line #%d(%d): cannot use %s.\n", yylineno, error_position + 1, yytext);
  return ERROR;
  }

%%
int yywrap(void){
  return 1;
}