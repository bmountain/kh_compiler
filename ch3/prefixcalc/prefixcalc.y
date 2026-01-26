%{
#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
int yylex(void);
void yyerror(const char*);

%}

%start line;
%token NUM;

%%

line: expr '\n' {printf("%d\n", $1);};
expr: '+' expr expr {$$ = $2 + $3;};
    | '*' expr expr {$$ = $2 * $3;}
    | NUM;
%%

int yylex(void)
{
  int c;

  while((c = getchar()) == ' ')
    ;

  if (!isdigit(c))
    return c;

  yylval = c - '0';
  while (isdigit(c = getchar()))
    yylval = 10 * yylval + c - '0';
  ungetc(c, stdin);
  return NUM;
}

void yyerror(const char* s)
{
  fprintf(stderr, "%s\n", s);
  exit(1);
}