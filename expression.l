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
";" { error_position += strlen(yytext); return SEMI_COLON; }
"int" { error_position += strlen(yytext); return INTEGER_DECLARE; }
"double" { error_position += strlen(yytext); return DOUBLE_DECLARE; }
[0-9]*[.][0-9]+   { 
  /* DOUBLE */ 
  yylval.str = (char*)malloc(sizeof(yytext) + 1);
  strcpy(yylval.str, yytext);
  //yylval.dval = atof(yytext);
  error_position += strlen(yytext);
  return DOUBLE; 
}
0|[1-9][0-9]* { 
  /* INTEGER */ 
  yylval.str = (char*)malloc(sizeof(yytext) + 1);
  strcpy(yylval.str, yytext);
  //yylval.ival = atof(yytext);
  error_position += strlen(yytext);
  return INTEGER; 
}
[A-Za-z]+[A-Za-z0-9]* { 
  /* ID */ 
  yylval.str = (char*)malloc(sizeof(yytext) + 1);
  strcpy(yylval.str, yytext);
  error_position += strlen(yytext);
  return ID; 
}
"\n" { error_position = 0; return NEW_LINE;};
[ \t] { error_position += strlen(yytext); };
. { 
  printf("Lexical Error in line #%d(%d): cannot use %s.\n", yylineno, error_position + 1, yytext);
  return ERROR; 
  }

%%
int yywrap(void){
  return 1;
}