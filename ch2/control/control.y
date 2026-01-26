%{
#include <stdlib.h>  
#include <stdio.h>

int yylex(void);
void yyerror(const char*);
%}

%%

input: sentence '\n' ;
sentence : if | while | compound | statement ;
if   : 'i' '(' variable ')' sentence ;
while : 'w' '(' variable ')' sentence ;
compound: '{' statement_sequence '}' ;
statement_sequence: sentence | statement_sequence sentence ;
statement: variable '=' value ';' ;
variable : 'x' ;
value : '1';

%%

int yylex(void)
{
  return getchar();
}

void yyerror(const char* s)
{
  fprintf(stderr, "%s\n", s);
}
