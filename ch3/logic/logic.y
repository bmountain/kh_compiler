%{
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char*);

%}

%token BOOL
%start line

%%

line: expr '\n' {if ($$){printf("true\n");} else {printf("false\n");}}
expr: BOOL
    | '(' '&' expr expr ')' {$$ = $3 & $4;}
    | '(' '|' expr expr ')' {$$ = $3 | $4;}
    | '(' '^' expr expr ')' {$$ = $3 ^ $4;}
    | '(' '~' expr ')' {$$ = 1 - $3 ;}

%%

int yylex(void)
{
  int c;
  while((c = getchar()) == ' ')
    ;
  if (c == 'T'){
    yylval = 1;
    return BOOL;
  }
  if (c == 'F'){
    yylval = 0;
    return BOOL;
  }
  return c;
}

void yyerror(const char* s)
{
  fprintf(stderr, "%s\n", s);
  exit(1);
}