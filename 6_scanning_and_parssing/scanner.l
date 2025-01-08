%{
#include "y.tab.h"  // Make sure you include the token definitions from Bison
%}

%%
"True"    { return TRUE; }
"False"   { return FALSE; }
"def"     { return DEF; }
"return"  { return RETURN; }
"if"      { return IF; }
"else"    { return ELSE; }
"while"   { return WHILE; }
"for"     { return FOR; }
"in"      { return IN; }
"print"   { return PRINT; }
"input"   { return INPUT; }

[a-zA-Z_][a-zA-Z0-9_]* { return IDENTIFIER; }

[0-9]+    { return INT_CONST; }

"+"       { return PLUS; }
"-"       { return MINUS; }
"*"       { return MUL; }
"/"       { return DIV; }
"="       { return ASSIGN; }
"<"       { return LT; }
">"       { return GT; }
"=="      { return EQ; }
"("       { return LPAREN; }
")"       { return RPAREN; }
"{"       { return LBRACE; }
"}"       { return RBRACE; }
","       { return COMMA; }
";"       { return SEMICOLON; }
"\n"      { return NEWLINE; }

"\"([^\"]|\\\")*\""   { return STRING_CONST; }
%%


int yywrap() {
    return 1;
}
