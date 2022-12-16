#pragma once
#define MAX_TABLE_SIZE 1000
#define MAX_TOKEN_SIZE 1000
#define MAX_LINE_LENGTH 1000
#define MAX_STRING_SIZE 100

#define INTEGER_TYPE 31
#define DOUBLE_TYPE 32

#define TRUE 1
#define FALSE 0

typedef struct Symbol {
    int type;
    char* name;
    int offset;
}Symbol;

/* Symbol 처리 관련 */
int declareId(int type, char* name);
int checkIdx(char* name);