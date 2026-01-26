%{
#include <stdio.h>
#include <stdlib.h>
void yyerror(const char*);
int yylex(void);
int isWhiteSpace(int c);
int isValidChar(int c);
%}

%start input

%%
input: line
     | input line
     ;

line : expr '\n' {printf("%d\n", $1);}
    ;

expr : expr '+' term {$$ = $1 + $3;}
    | expr '-' term {$$ = $1 - $3;}
    | term
    ;

term : term '*' factor {$$ = $1 * $3;}
    | term '/' factor {if ($3 == 0) {yyerror("Zero divistion."); exit(1);} ; $$ = $1 / $3;}
    | term '%' factor {$$ = $1 % $3;}
    | factor
    ;

factor : '(' expr ')' {$$ = $2;}
      | '0' {$$ = 0;}
      | '1' {$$ = 1;}
      | '2' {$$ = 2;}
      | '3' {$$ = 3;}
      | '4' {$$ = 4;}
      | '5' {$$ = 5;}
      | '6' {$$ = 6;}
      | '7' {$$ = 7;}
      | '8' {$$ = 8;}
      | '9' {$$ = 9;}
      | '-' factor {$$ = - $2;}
      ;

%%

int yylex()
{
  int c;
  while(!isValidChar(c = getchar()) || c == ' ' || c == '\t')
    ;
  return c;
}

void yyerror(const char* s)
{
  fprintf(stderr, "%s\n", s);
}

int isValidChar(int c)
{
  if (c == ' ' || c == '\t' || c == '\n' || c == EOF)
    return 1;
  if (c == '(' || c == ')')
    return 1;
  if (c == '+' || c == '-'|| c== '*' || c == '/' || c=='%')
    return 1;
  if (c >= '0' && c <= '9')
    return 1;
    
  fprintf(stderr, "ignoring invalid character: %c.\n", c);
  return 0;
}