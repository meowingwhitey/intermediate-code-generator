#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<math.h>
#include "parser.h"
#include "evaluate.h"

extern int yylex();
extern int yylineno;
extern char* yytext;

Token lookahead;
Symbol symbol_table[MAX_TABLE_SIZE];
int symbol_table_size = 0;
Node* ast;
int syntax_error = FALSE;
int lexical_error = FALSE;
int runtime_error = FALSE;
int char_pos = 0;
int lineno = 0;
char error_str[MAX_LINE_LENGTH];

int main(void){
    while(TRUE){
        lexical_error = FALSE; syntax_error = FALSE; runtime_error = FALSE;
        char_pos = 0; lineno ++;
        scanToken();
        if(yytext[0] == '\n'){
            continue;
        }
        if(lookahead.type == END_OF_FILE){
            break;
        }
        if(lexical_error == TRUE){
            while(lookahead.type != NEW_LINE){scanToken();}
            continue;
        }
        if(syntax_error == TRUE){
            while(lookahead.type != NEW_LINE){scanToken();}
            continue;
        }
        printEval();
    } 
    finalize();
    return 0;
}

void lexicalError(){

}
void syntaxError(char* cause){
    printf("Syntax Error in line #%d: Unexpected token %s in %s expression.\n", lineno, error_str, cause);
}

void runtimeError(){
    printf("Runtime Error in line #%d: ", lineno);
}