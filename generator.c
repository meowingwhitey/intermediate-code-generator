#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<math.h>
#include "generator.h"
#include "grammar.tab.h"
/*
#ifdef YYDEBUG
  yydebug = 1;
#endif
*/
extern int yylex();
extern int yyparse();
extern void yyerror();
extern int yylineno;
extern char* yytext;
extern FILE *yyin;
#define INTEGER_SIZE 4
#define DOUBLE_SIZE 8
Symbol symbol_table[MAX_TABLE_SIZE];
int symbol_table_size = 0;
int syntax_error = FALSE;
int lexical_error = FALSE;
int error_position = 0;
int lineno = 0;
int symbol_offset = 0;
char error_str[MAX_LINE_LENGTH];
FILE* ic;
FILE* sbt;

int main(void){
    yyin = stdin;
    ic = fopen("ic.out", "w");
    sbt = fopen("sbt.out", "w");
    yyparse();
    return 0;
}

void writeSymbolTable(void){
    int i = 0;
    char temp_type[10] = {NULL, };
    for(i = 0; i < symbol_table_size; i++){
        switch(symbol_table[i].type){
            case INTEGER:
                strcpy(temp_type, "int");
                break;
            case DOUBLE:
                strcpy(temp_type, "double");
                break;
            default:
                fprintf(stderr, "Symbol Table Error!\n");
                break;
        }
        fprintf(stderr, "%s %s %d\n", temp_type, symbol_table[i].name, symbol_table[i].offset);
        fprintf(sbt, "%s %s %d\n", temp_type, symbol_table[i].name, symbol_table[i].offset);
    }
    return;
}

int declareId(int type, char* name){
    // 이미 선언되어 있을 경우
    if(checkIdx(name) != -1){
        return -1;
    }
    int size = symbol_table_size;
    // variable 길이 제한
    int id_length = strlen(name);
    if(id_length > 10){
        name[10] = NULL;
    }
    symbol_table[size].name = name;
    if(type == DOUBLE_DECLARE){
        symbol_table[size].offset = symbol_offset;
        symbol_offset += DOUBLE_SIZE;
        symbol_table[size].type = DOUBLE;
    }
    if(type == INTEGER_DECLARE){
        symbol_table[size].offset = symbol_offset;
        symbol_offset += INTEGER_SIZE;
        symbol_table[size].type = INTEGER;
    }
    return symbol_table_size++;
}

int getType(char* name){
    int index = checkIdx(name);
    if (index == -1){
        yyerror();
        return -1;
    }
    return symbol_table[index].type;
}

int checkIdx(char* name){
    int id_length = strlen(name);
    if(id_length > 10){ name[10] = NULL; }
    for(int i = 0; i < symbol_table_size; i++){
        if(strcmp(symbol_table[i].name, name) == 0){
            return i;
        }
    }
    return -1;
}