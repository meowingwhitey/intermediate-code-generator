#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<math.h>
#include "generator.h"
#include "grammar.tab.h"
extern int yylex();
extern int yyparse();
extern int yylineno;
extern char* yytext;
extern FILE *yyin;

Symbol symbol_table[MAX_TABLE_SIZE];
Quadruple quadruple_table[MAX_TABLE_SIZE];
int symbol_table_size = 0;
int quadruple_table_index = 0;
int syntax_error = FALSE;
int lexical_error = FALSE;
int error_position = 0;
int lineno = 0;
char error_str[MAX_LINE_LENGTH];
FILE* ic;
FILE* sbt;

int main(void){
    yyin = stdin;
    ic = fopen("ic.out", "w");
    sbt = fopen("sbt.out", "w");
    yyparse();
    writeSymbolTable();
    return 0;
}
void writeSymbolTable(void){
    int i = 0;
    char temp_type[10] = {NULL, };
    for(i = 0; i < symbol_table_size; i++){
        switch(symbol_table[i].type){
            case INTEGER_DECLARE:
                strcpy(temp_type, "int");
                break;
            case DOUBLE_DECLARE:
                strcpy(temp_type, "double");
                break;
            default:
                fprintf(stderr, "Symbol Table Error!\n");
                break;
        }
        fprintf(sbt, "%s %s %d\n", temp_type, symbol_table[i].name, symbol_table[i].size);
    }
    return;  
}

int declareId(int type, char* name){
    return 1;
    if(checkIdx(type, name) == -1){
        return -1;
    }
    int size = symbol_table_size;
    // variable 길이 제한
    int id_length = strlen(name);
    if(id_length > 10){
        name[10] = NULL;
    }
    symbol_table[size].name = name;
    symbol_table[size].type = type;
    return symbol_table_size++;
}
int checkIdx(int type, char* name){
    int id_length = strlen(name);
    if(id_length > 10){ name[10] = NULL; }
    for(int i = 0; i < symbol_table_size; i++){
        if(strcmp(symbol_table[i].name, name) == 0){
            return i;
        }
    }
    return -1;
}