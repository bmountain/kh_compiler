%{
#include <stdio.h>
#include <stdlib.h>
int yylex(void);
void yyerror(const char* s);
%}

%%

input     : expr '\n' {printf("\n");};

expr      : expr '+' term {printf("+");}
          | expr '-' term {printf("-");} 
          | term 
          ;

term      : term '*' factor {printf("*");}
          | term '/' factor {printf("/");}
          | factor 
          ;

factor    : 'i' {printf("i");}
          | '(' expr ')' 
          ;

%%

int yylex()
{
  return getchar();
}

void yyerror(const char* s)
{
  fprintf(stderr, "%s\n", s);
}