%{
#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#define TEMP 256
int temp = TEMP;
int yylex();
void yyerror(char*);
char* conv(int n);
%}



%start line;
%token ALPHA;

%%

line: eq '\n'
    ;
eq  : var '=' exp {
    char* s3 = conv($3);
    printf("%c = %s\n", $1, s3);
    free(s3);
  }
    ;
exp : exp '+' term {
     $$ = ++temp;
     char* s0 = conv($$);
     char* s1 = conv($1);
     char* s3 = conv($3);
     printf("%s = %s + %s\n", s0, s1, s3);
     free(s0);
     free(s1);
     free(s3);
}
    | exp '-' term {
      $$ = ++temp;
     char* s0 = conv($$);
     char* s1 = conv($1);
     char* s3 = conv($3);
      printf("%s = %s - %s\n", s0, s1, s3);
     free(s0);
     free(s1);
     free(s3);
      }
    | '-' term 
    {
      $$ = ++temp;
      char* s0 = conv($$);
      char* s2 = conv($2);
      printf("%s = - %s\n", s0, s2); 
      free(s0);
      free(s2);
    }
    | term
    ;
term : term '*' factor 
     {
     $$ = ++temp;
     char* s0 = conv($$);
     char* s1 = conv($1);
     char* s3 = conv($3);
     printf("%s = %s * %s\n", s0, s1, s3);
     free(s0);
     free(s1);
     free(s3);
     }
    | term '/' factor {
      $$ = ++temp;
      char* s0 = conv($$);
      char* s1 = conv($1);
      char* s3 = conv($3);
      printf("%s = %s / %s\n", s0, s1, s3);
      free(s0);
      free(s1);
      free(s3);
      }
    | factor
    ;
factor: '(' exp ')' { $$ = $2; }
      |  var 
      ;

var: ALPHA

%%

int yylex()
{
  int c;
  while((c = getchar()) == ' ')
    ;
  if ('a' <= c && c <= 'z'){
    yylval = c;
    return ALPHA;
  }
  return c;
}

void yyerror(char* s)
{
  fprintf(stderr, "%s\n", s);
}

char* conv(int n)
{
  char* s;
  if (n < TEMP){
    s = malloc(sizeof(char) * 2);
    sprintf(s, "%c", n);
    return s;
  }
  else {
    s = malloc(sizeof(char) * 4);    
    sprintf(s, "t_%d", n - TEMP);
    return s;
  }
}