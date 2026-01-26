%{
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <stdckdint.h>

int ipower(int, int);
int yylex(void);
void yyerror(const char*);
%}

%token NUM UMINUS

%left LSHIFT RSHIFT
%left '+' '-'
%left '*' '/'
%right '^'
%right UMINUS

%%

line :
     | line expr '\n' {printf("%d\n", $2);}
     ;

expr: expr '+' expr {$$ = $1 + $3;}
    | expr '-' expr {$$ = $1 - $3;}
    | expr '*' expr {$$ = $1 * $3;}
    | expr '/' expr {$$ = $1 / $3;}
    | expr '^' expr {$$ = ipower($1, $3);}
    | '-' expr %prec UMINUS {$$ = - $2;}
    | expr LSHIFT expr {$$ = $1 << $3;}
    | expr RSHIFT expr {$$ = $1 >> $3;}
    | '(' expr ')' {$$ = $2;}
    | NUM
    ;

%%

int yylex()
{
  int c, d;  
  while((c = getchar()) == ' ')
    ;
  if (isdigit(c)){
    yylval = c - '0';
    while(isdigit(c = getchar())){
      yylval = 10 * yylval + c - '0';
    }
    ungetc(c, stdin);
    return NUM;
  }
  
  if (c == '<'){
    if ((d = getchar()) == '<')
      return LSHIFT;
    else{
      ungetc(d, stdin);
      return c;
    }
  }
  
  if (c == '>'){
    if ((d = getchar()) == '>')
      return RSHIFT;
    else {
      ungetc(d, stdin);
      return c;
    }
  }

  return c;
}

int ipower(int m, int n)
{
  if (n < 0)
    return 0;
  
  int e = 1;
  for (; n > 0; --n){
    int res;
    if (ckd_mul(&res, e, m)){
      fprintf(stderr, "overflow.\n");
      exit(1);
    }
    e = res;
  }
  return e;
}

void yyerror(const char* s)
{
  fprintf(stderr, "%s\n", s);
  exit(1);
}