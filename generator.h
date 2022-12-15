#pragma once
#define MAX_TABLE_SIZE 1000
#define MAX_TOKEN_SIZE 1000
#define MAX_LINE_LENGTH 1000
#define MAX_STRING_SIZE 100

#define TRUE 1
#define FALSE 0
typedef struct Symbol {
    int type;
    char* name;
    int size;
}Symbol;

typedef struct Quadruple{
    int op;
    char arg1[11];
    char arg2[11];
    char result[11];
}Quadruple;

/* Symbol 처리 관련 */
void writeSymbolTable(void);
int declareId(int type, char* name);
int checkIdx(int type, char* name);