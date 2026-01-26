%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <stdckdint.h>
int yylex(void);
void yyerror(const char*);
void parse_decimal();
void parse_octal();
void parse_hex();
int hex_to_digit(int c);
int factorial(int n);
%}

%token NUM;

%%

line: expr '\n' {printf("%d\n", $1);}
    ;

expr: expr '+' term {$$ = $1 + $3;}
    | expr '-' term {$$ = $1 - $3;}
    | term;
term: term '*' factor {$$ = $1 * $3;}
    | term '/' factor {if ($3 == 0) {yyerror("zero division."); exit(1);}; $$ = $1 / $3;}
    | factor;
    | '-' factor {$$ = - $2 ;}
factor: NUM
    | '(' expr ')' {$$ = $2;}
    | factor '!' {$$ = factorial($1); }
    | '|' expr '|' {$$ = abs($2);}
    ;
%%

int yylex(void)
{
  int c;
  while ((c = getchar()) == ' ')
    ;
  if (isdigit(c)){
    if (c != '0'){
      ungetc(c, stdin);
      parse_decimal();
      return NUM;
    }
    int d = getchar();
    if (d == 'x' || d == 'X'){
      parse_hex();
      return NUM;
    }
    ungetc(d, stdin);
    parse_octal();
    return NUM;
  }
  return c;
}

void yyerror(const char* s)
{
  fprintf(stderr, "%s\n", s);
}

void parse_decimal()
{
  int c = getchar();
  yylval = c - '0';
  while (isdigit(c = getchar())){
    if (ckd_mul(&yylval, 10, yylval) || ckd_add(&yylval, yylval, c - '0')){
      fprintf(stderr, "overfllow.\n");
      exit(1);
    }
  }
  ungetc(c, stdin);
}

void parse_octal()
{
  int c = getchar();
  if (!isdigit(c)){
    ungetc(c, stdin);
    yylval = 0;
    return;
  }
  yylval = c - '0';
  while(isdigit(c = getchar()) && c <= '7'){
    yylval = 8 * yylval + c - '0';
  }
  ungetc(c, stdin);
}

void parse_hex()
{
  int c;
  int val = hex_to_digit(c = getchar());
  if (val == -1){
    fprintf(stderr, "hex number parse error.\n");
    exit(1);
  }
  yylval = val;
  
  while ((val = hex_to_digit(c = getchar())) != -1){
    yylval = yylval * 16 + val;
  }

  ungetc(c, stdin);
}

int hex_to_digit(int c)
{
  if (c >= '0' && c <= '9')
    return c - '0';
  if (c >= 'A' && c <= 'F')
    return c - 'A' + 10;
  return -1;
}

int factorial(int n)
{
   if (n < 0){
    fprintf(stderr, "factorial error.\n");
    exit(1);
   }

  if (n < 2) {
    return 1;
  }
  return factorial(n-1) * n;
}