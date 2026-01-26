%{
#include <stdlib.h>
#include <stdio.h>

int yylex(void);
void yyerror(const char* s);
%}

%left AND OR
%right NOT
%token TRUE FALSE

%%

line :
     | line expr '\n' {if($2){printf("True\n");} else {printf("False\n");}}
     ;

expr : expr AND expr {$$ = $1 & $3;}
     | expr OR expr {$$ = $1 | $3;}
     | '(' expr ')' {$$ = $2;}
     | NOT expr {$$ = ~ $2;}
     | TRUE {$$ = 1;}
     | FALSE {$$ = 0;}
     ;

%%

int yylex(void)
{
  int c;
  while ((c = getchar()) == ' ' || c == '\t')
    ;
  switch(c){
    case 'T': return TRUE;
    case 'F': return FALSE;
    case '&': return AND;
    case '|': return OR;
    case '~': return NOT;
    default: return c;
  }
}
void yyerror(const char* s)
{
  printf("%s\n", s);
}