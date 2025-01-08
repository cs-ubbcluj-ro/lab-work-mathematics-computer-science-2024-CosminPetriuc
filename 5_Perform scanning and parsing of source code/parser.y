%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
%}

%token INT_CONST STRING_CONST IDENTIFIER
%token LT GT EQ PLUS MINUS MUL DIV ASSIGN SEMICOLON COMMA LPAREN RPAREN LBRACE RBRACE NEWLINE
%token TRUE FALSE DEF RETURN IF ELSE WHILE FOR IN PRINT INPUT

%%

program:
    stmtlist
;

stmtlist:
    stmt
    | stmt NEWLINE stmtlist
;

stmt:
    simplstmt
    | structstmt
;

simplstmt:
    assignstmt
    | iostmt
    | returnstmt
;

assignstmt:
    IDENTIFIER ASSIGN expression
;

iostmt:
    PRINT LPAREN expression RPAREN
    | INPUT LPAREN RPAREN
;

returnstmt:
    RETURN expression
;

structstmt:
    ifstmt
    | whilestmt
    | functionstmt
;

ifstmt:
    IF condition SEMICOLON stmtlist ELSE SEMICOLON stmtlist
;

whilestmt:
    WHILE condition SEMICOLON stmtlist
;

functionstmt:
    DEF IDENTIFIER LPAREN RPAREN SEMICOLON stmtlist
;

condition:
    expression LT expression
    | expression GT expression
    | expression EQ expression
;

expression:
    expression PLUS term
    | expression MINUS term
    | term
;

term:
    term MUL factor
    | term DIV factor
    | factor
;

factor:
    LPAREN expression RPAREN
    | IDENTIFIER
    | INT_CONST
    | STRING_CONST
    | TRUE
    | FALSE
;

%%

int main() {
    return yyparse();
}

int yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
    return 0;
}
