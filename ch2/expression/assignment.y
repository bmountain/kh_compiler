%{
#include <stdio.h>
#include <stdlib.h>
int yylex(void);
void yyerror(const char*);
%}

%%
input: exp '\n' ;
exp: identifier '=' number ;
number : '0' | '1' | '2' ;
identifier : 'a' | 'b' | 'c' ;
%%

int yylex(void)
{
  return getchar();
}

void yyerror(const char* s)
{
  fprintf(stderr, "%s\n", s);
}
