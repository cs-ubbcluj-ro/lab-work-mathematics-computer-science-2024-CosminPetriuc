%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"

int productions_used[1000];
int prod_count = 0;

#define RECORD_PRODUCTION(num) \
    do { \
        productions_used[prod_count++] = (num); \
    } while (0)

void yyerror(const char *s);
%}

%token INT_CONST STRING_CONST IDENTIFIER
%token LT GT EQ PLUS MINUS MUL DIV ASSIGN SEMICOLON COMMA LPAREN RPAREN LBRACE RBRACE NEWLINE
%token TRUE FALSE DEF RETURN IF ELSE WHILE FOR IN PRINT INPUT

%%

program:
    stmtlist
    { RECORD_PRODUCTION(1); printf("Program parsed successfully.\n"); }
;

stmtlist:
    stmt
    { RECORD_PRODUCTION(2); }
    | stmt NEWLINE stmtlist
    { RECORD_PRODUCTION(3); }
;

stmt:
    simplstmt
    { RECORD_PRODUCTION(4); }
    | structstmt
    { RECORD_PRODUCTION(5); }
;

simplstmt:
    assignstmt
    { RECORD_PRODUCTION(6); }
    | iostmt
    { RECORD_PRODUCTION(7); }
    | returnstmt
    { RECORD_PRODUCTION(8); }
;

assignstmt:
    IDENTIFIER ASSIGN expression
    { RECORD_PRODUCTION(9); }
;

iostmt:
    PRINT LPAREN expression RPAREN
    { RECORD_PRODUCTION(10); }
    | INPUT LPAREN RPAREN
    { RECORD_PRODUCTION(11); }
;

returnstmt:
    RETURN expression
    { RECORD_PRODUCTION(12); }
;

structstmt:
    ifstmt
    { RECORD_PRODUCTION(13); }
    | whilestmt
    { RECORD_PRODUCTION(14); }
    | functionstmt
    { RECORD_PRODUCTION(15); }
;

ifstmt:
    IF condition SEMICOLON stmtlist ELSE SEMICOLON stmtlist
    { RECORD_PRODUCTION(16); }
;

whilestmt:
    WHILE condition SEMICOLON stmtlist
    { RECORD_PRODUCTION(17); }
;

functionstmt:
    DEF IDENTIFIER LPAREN RPAREN SEMICOLON stmtlist
    { RECORD_PRODUCTION(18); }
;

condition:
    expression LT expression
    { RECORD_PRODUCTION(19); }
    | expression GT expression
    { RECORD_PRODUCTION(20); }
    | expression EQ expression
    { RECORD_PRODUCTION(21); }
;

expression:
    expression PLUS term
    { RECORD_PRODUCTION(22); }
    | expression MINUS term
    { RECORD_PRODUCTION(23); }
    | term
    { RECORD_PRODUCTION(24); }
;

term:
    term MUL factor
    { RECORD_PRODUCTION(25); }
    | term DIV factor
    { RECORD_PRODUCTION(26); }
    | factor
    { RECORD_PRODUCTION(27); }
;

factor:
    LPAREN expression RPAREN
    { RECORD_PRODUCTION(28); }
    | IDENTIFIER
    { RECORD_PRODUCTION(29); }
    | INT_CONST
    { RECORD_PRODUCTION(30); }
    | STRING_CONST
    { RECORD_PRODUCTION(31); }
    | TRUE
    { RECORD_PRODUCTION(32); }
    | FALSE
    { RECORD_PRODUCTION(33); }
;

%%

int main() {
    if (yyparse() == 0) {
        printf("Parsing completed successfully.\nProductions used: ");
        for (int i = 0; i < prod_count; i++) {
            printf("%d ", productions_used[i]);
        }
        printf("\n");
    } else {
        printf("Parsing failed.\n");
    }
    return 0;
}

int yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
    if (prod_count > 0) {
        printf("Error occurred at production %d\n", productions_used[prod_count - 1]);
    } else {
        printf("Error occurred before any production was reduced.\n");
    }
    return 0;
}
