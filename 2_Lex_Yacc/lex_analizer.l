%{
#include <string.h>
#include <stdio.h>

typedef struct {
    char token[257];
    int symbolTableCode;
} PIF;

typedef struct {
    char token[257];
    int index;
} ST;

ST SymbolTable[100];
int stLength = 0;

PIF ProgramInternalForm[300];
int pifLength = 0;

int errorFound = 0;
int lineNumber = 1;

/* Function Prototypes */
int addToSymbolTable(char* token);
void addToProgramInternalForm(char* token, int stCode);
void showSymbolTable();
void showProgramInternalForm();

/* Function Definitions */
int addToSymbolTable(char* token) {
    for (int i = 0; i < stLength; i++) {
        if (strcmp(SymbolTable[i].token, token) == 0) {
            return SymbolTable[i].index;
        }
    }
    strcpy(SymbolTable[stLength].token, token);
    SymbolTable[stLength].index = stLength;
    stLength++;
    return stLength - 1;
}

void addToProgramInternalForm(char* token, int stCode) {
    strcpy(ProgramInternalForm[pifLength].token, token);
    ProgramInternalForm[pifLength].symbolTableCode = stCode;
    pifLength++;
}

void showSymbolTable() {
    printf("--------------- Symbol Table ---------------\n");
    for (int i = 0; i < stLength; i++) {
        printf(" %s -> %d\n", SymbolTable[i].token, SymbolTable[i].index);
    }
    printf("--------------------------------------------\n");
}

void showProgramInternalForm() {
    printf("--------------- Program Internal Form ---------------\n");
    for (int i = 0; i < pifLength; i++) {
        printf(" %s -> %d\n", ProgramInternalForm[i].token, ProgramInternalForm[i].symbolTableCode);
    }
    printf("-----------------------------------------------------\n");
}
%}

/* Regular Expressions */
IDENTIFIER [a-zăîșțâ][a-z0-9_ăîșțâ]*
INT     [+-]?(0|[1-9][0-9]*)
STRING     \"[^\"]*\"    

/* Lexical Rules */
%%
"def"|"return"|"if"|"else"|"while"|"for"|"in"|"True"|"False"|"print"|"input" {
    addToProgramInternalForm(yytext, -1);
}

"+"|"-"|"*"|"/"|"="|"<"|">"|"=="|"("|")"|"{"|"}"|"|"|","|";"|":" {
    addToProgramInternalForm(yytext, -1);
}

{IDENTIFIER}                             { int stCode = addToSymbolTable(yytext); addToProgramInternalForm(yytext, stCode); }
{INT}                                 { int stCode = addToSymbolTable(yytext); addToProgramInternalForm(yytext, stCode); }
{STRING}                                 { int stCode = addToSymbolTable(yytext); addToProgramInternalForm(yytext, stCode); }

\n {
    lineNumber++;
}

[ \t]+ {
    /* Ignore whitespace */
}

. {
    errorFound = 1;
    printf("Lexical error at line %d: Unknown symbol '%s'\n", lineNumber, yytext);
}
%%

int yywrap() { return 1; }

int main(int argc, char **argv) {
    if (argc < 2) {
        printf("Usage: %s <source_file>\n", argv[0]);
        return 1;
    }

    FILE *fp = fopen(argv[1], "r");
    if (!fp) {
        printf("Error: Could not open file %s\n", argv[1]);
        return 1;
    }

    yyin = fp;
    yylex();

    if (!errorFound) {
        showSymbolTable();
        showProgramInternalForm();
    }

    fclose(fp);
    return 0;
}

