 %{
#include <stdio.h>
#include "generator.h"
void yyerror(); 
void gen(char*, char*, char*, char*, char*);
char* newTemp();
int yylex(void);
int declareId();
int temp_index = 1;
char symbol[11];
extern int error_position;
extern int syntax_error;
extern FILE* yyin;
extern FILE* ic;
extern char* yytext;
extern int yylineno;
%}
%union{
    //[0]: addr, [1]: type
    char* attr[2];
}
%token ID 11 INTEGER 12 DOUBLE 13 INTEGER_DECLARE 14 DOUBLE_DECLARE 15
%token LP 21 RP 22 LS 23 RS 24 SEMI_COLON
%token ADD 31 SUB 32 MUL 33 DIV 34 ASSIGN 35 ERROR 60
%type <attr> ID
%type <attr> INTEGER
%type <attr> DOUBLE
%type <attr> expression  
%type <attr> statement  
%right ASSIGN
%left ADD SUB
%left MUL DIV
%% 
code: code statement SEMI_COLON | statement SEMI_COLON;

statement:
    INTEGER_DECLARE ID {
        if(declareId(INTEGER_DECLARE, $2[0]) == -1){
            yyerror();
            //yyerrok;
        }
    }
    | DOUBLE_DECLARE ID {    
        if(declareId(DOUBLE_DECLARE, $2[0]) == -1){
            yyerror();
            //yyerrok;
        } 
    }
    | ID ASSIGN expression {
        gen($1[0], "=", $3[0], NULL, NULL);
    }
    ;

expression:
    INTEGER {
        $$[0] = $1[0];
        $$[1] = $1[1] = INTEGER;
    }
    | DOUBLE { 
        $$[0] = $1[0];
        $$[1] = $1[1] = DOUBLE;
    }
    | ID { 
        $$[0] = $1[0];
        $$[1] = $1[1] = getType($1[0]);
    }
    | expression ADD expression {
        if ($1[1] == INTEGER && $3[1] == INTEGER){
            $$[0] = newTemp();
            gen($$[0], "=", $1[0], "+", $3[0]);
            $$[1] = INTEGER;
        }
        else if ($1[1] == DOUBLE && $3[1] == DOUBLE){
            $$[0] = newTemp();
            gen($$[0], "=", $1[0], "+", $3[0]);
            $$[1] = DOUBLE;
        }
        else if ($1[1] == INTEGER && $3[1] == DOUBLE){
            char* u = newTemp();
            $$[0] = newTemp();
            gen(u, "=", "inttoreal", $1[0], NULL);
            gen($$[0], "=", u, "+", $3[0]);
            $$[1] = DOUBLE;
        }
        else if ($1[1] == DOUBLE && $3[1] == INTEGER){
            char* u = newTemp();
            $$[0] = newTemp();
            gen(u, "=", "inttoreal", $3[0], NULL);
            gen($$[0], "=", $1[0], "+", u);
            $$[1] = DOUBLE; 
        }
        else{
            $$[1] = ERROR;
            yyerror();
            //yyerrok;
        }
    }
    | expression SUB expression {
        if ($1[1] == INTEGER && $3[1] == INTEGER){
            $$[0] = newTemp();
            gen($$[0], "=", $1[0], "-", $3[0]);
            $$[1] = INTEGER;
        }
        else if ($1[1] == DOUBLE && $3[1] == DOUBLE){
            $$[0] = newTemp();
            gen($$[0], "=", $1[0], "-", $3[0]);
            $$[1] = DOUBLE;
        }
        else if ($1[1] == INTEGER && $3[1] == DOUBLE){
            char* u = newTemp();
            $$[0] = newTemp();
            gen(u, "=", "inttoreal", $1[0], NULL);
            gen($$[0], "=", u, "-", $3[0]);
            $$[1] = DOUBLE;
        }
        else if ($1[1] == DOUBLE && $3[1] == INTEGER){
            char* u = newTemp();
            $$[0] = newTemp();
            gen(u, "=", "inttoreal", $3[0], NULL);
            gen($$[0], "=", $1[0], "-", u);
            $$[1] = DOUBLE; 
        }
        else{
            $$[1] = ERROR;
            yyerror();
            //yyerrok;
        } 
    } 
    | expression MUL expression { 
        if ($1[1] == INTEGER && $3[1] == INTEGER){
            $$[0] = newTemp();
            gen($$[0], "=", $1[0], "*", $3[0]);
            $$[1] = INTEGER;
        }
        else if ($1[1] == DOUBLE && $3[1] == DOUBLE){
            $$[0] = newTemp();
            gen($$[0], "=", $1[0], "*", $3[0]);
            $$[1] = DOUBLE;
        }
        else if ($1[1] == INTEGER && $3[1] == DOUBLE){
            char* u = newTemp();
            $$[0] = newTemp();
            gen(u, "=", "inttoreal", $1[0], NULL);
            gen($$[0], "=", u, "*", $3[0]);
            $$[1] = DOUBLE;
        }
        else if ($1[1] == DOUBLE && $3[1] == INTEGER){
            char* u = newTemp();
            $$[0] = newTemp();
            gen(u, "=", "inttoreal", $3[0], NULL);
            gen($$[0], "=", $1[0], "*", u);
            $$[1] = DOUBLE; 
        }
        else{
            $$[1] = ERROR;
            yyerror();
            //yyerrok;
        } 
    }
    | expression DIV expression {
        if ($1[1] == INTEGER && $3[1] == INTEGER){
            $$[0] = newTemp();
            gen($$[0], "=", $1[0], "/", $3[0]);
            $$[1] = INTEGER;
        }
        else if ($1[1] == DOUBLE && $3[1] == DOUBLE){
            $$[0] = newTemp();
            gen($$[0], "=", $1[0], "/", $3[0]);
            $$[1] = DOUBLE;
        }
        else if ($1[1] == INTEGER && $3[1] == DOUBLE){
            char* u = newTemp();
            $$[0] = newTemp();
            gen(u, "=", "inttoreal", $1[0], NULL);
            gen($$[0], "=", u, "/", $3[0]);
            $$[1] = DOUBLE;
        }
        else if ($1[1] == DOUBLE && $3[1] == INTEGER){
            char* u = newTemp();
            $$[0] = newTemp();
            gen(u, "=", "inttoreal", $3[0], NULL);
            gen($$[0], "=", $1[0], "/", u);
            $$[1] = DOUBLE; 
        }
        else{
            $$[1] = ERROR;
            yyerror();
            //yyerrok;
        }
    }
    | SUB expression { 
        $$[0] = newTemp();
        gen($$[0], "=", "-", $2[0], NULL); 
        $$[1] = $2[1];
    }
    | ADD expression {         
        $$[0] = $2[0];
        $$[1] = $2[1];
    }
    | LP expression RP { 
        $$[0] = $2[0]; 
        $$[1] = $2[1]; 
    }
    
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