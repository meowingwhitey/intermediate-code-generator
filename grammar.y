 %{
#include <stdio.h>
#include "generator.h"
#define INTEGER_SIZE 4
#define DOUBLE_SIZE 8
void yyerror(); 
void gen(char*, char*, char*, char*, char*);
char* newTemp();
int yylex(void);
int declareId();
int temp_index = 0;
char symbol[11];
extern Quadruple quadruple_table[MAX_TABLE_SIZE];
extern int quadruple_table_index;
extern int error_position;
extern int syntax_error;
extern FILE* yyin;
extern FILE* ic;
extern char* yytext;
extern int yylineno;
%}
%union{
    char* str;
}
%token ID 11 INTEGER 12 DOUBLE 13 INTEGER_DECLARE 14 DOUBLE_DECLARE 15
%token LP 21 RP 22 LS 23 RS 24 SEMI_COLON 25  NEW_LINE 26  
%token ADD 31 SUB 32 MUL 33 DIV 34 ASSIGN 35 ERROR 60 END_OF_FILE 61
%type <str> ID
%type <str> INTEGER
%type <str> DOUBLE
%type <str> statement  
%type <str> expression  
%% 
program: 
    program statement SEMI_COLON NEW_LINE |;
statement: 
    ID ASSIGN expression {
        gen($$, "=", $3, NULL, NULL);
    }
    | INTEGER_DECLARE ID {
        if(declareId(INTEGER, $2) == -1){
            yyerror();
            yyerrok;
        }
    }
    | DOUBLE_DECLARE ID {     
        if(declareId(DOUBLE, $2) == -1){
            yyerror();
            yyerrok;
        } 
    }
    ;

expression:
    | INTEGER { $$ = $1; }
    | DOUBLE { $$ = $1; }
    | ID { $$ = $1; }
    | expression ADD expression { 
        $$ = newTemp();
        gen($$, "=", $1, "+", $3);
        /*
        if(E1.type = integer and E2.type = integer){
            gen(E.addr ‘=‘ E1. addr ‘int+’ E2.addr);            
            E.type = integer;
        }
        else if(E1.type = real and E2.type = real){
            gen(E. addr ‘=‘ E1. addr ‘real+’ E2addr);
            E.type = real;
        }
        else if(E1.type = integer and E2.type = real){
            u = newtemp;
            gen (u ‘=‘ ‘inttoreal’ E1. addr);
            gen (E. addr ‘=‘ u ‘real+’ E2. addr);
            E.type = real;
        }
        else if(E1.type = real and E2.type = integer){
            u = newtemp;
            gen (u ‘=‘ ‘inttoreal’ E2. addr);
            gen (E. addr ‘=‘ E1. addr ‘real+’ u);
             E.type = real; 
        }
        else{
            E.type = type_error;
        }
        */
    }
    | expression SUB expression { 
        $$ = newTemp();
        gen($$, "=", $1, "+", $3);
    } 
    | expression MUL expression { 
        $$ = newTemp();
        gen($$, "=", $1, "+", $3);
    }
    | expression DIV expression {
        $$ = newTemp();
        gen($$, "=", $1, "+", $3);
    }
    | SUB expression { 
        $$ = newTemp();
        gen($$, "=", "-", $2, NULL); 
    }
    | ADD expression { $$ = $2; }
    | LP expression RP { $$ = $2; }
    ;
    
%%
char* newTemp(){
    char s1[] = "t";
    char s2[MAX_TABLE_SIZE + 1];
    sprintf(s2, "%d\0", temp_index);
    temp_index++;
    char *res = malloc(strlen(s1) + strlen(s2));
    strcpy(res, s1);
    strcat(res, s2);
    return res;
}
void gen(char* arg1, char* arg2, char* arg3, char* arg4, char* arg5){
    char* args[] = {arg1, arg2, arg3, arg4, arg5};
    for(int i = 0; i < 5; i++){
        if(args[i] == NULL) continue;
        fprintf(ic, "%s ", args[i]);
    }
    fprintf(ic, "\n");
    return;
}
void yyerror() { fprintf(stderr, "Syntax Error in line #%d %s\n", yylineno, yytext); }