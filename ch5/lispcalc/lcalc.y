%{
#include <math.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "list.h"

int yyparse(void);
void yyerror(const char*);
int yylex(void);

List* make_list(double v);
List* extend_list(List* l, double v);
double sum_list(List* l);
double prod_list(List* l);

%}

%code requires {
#include "list.h"
}

%union
{
  int ival;
  double rval;
  List* lval;
}

%token EXP LOG SQRT
%token <ival> INTC
%token <rval> REALC

%left '+' '-'
%left '*' '/'
%nonassoc EXP LOG SQRT
/* %right UMINUS */

%type <rval> expr
%type <rval> func
%type <lval> list

%%

input:
    | input line
    ;

line: expr '\n' {printf("%f\n", $1);}
    | '\n'
    | error '\n' {yyerrok;}
    ;

expr: '(' func ')' {$$ = $2;}
    | INTC {$$ = (double) $1;}
    | REALC {$$ = $1;}
    ;

func: EXP expr {$$ = exp($2);}
    | LOG expr {$$ = log($2);}
    | SQRT expr {$$ = sqrt($2);}
    | '-' expr expr {$$ = $2 - $3;}
    | '/' expr expr {$$ = $2 / $3;}
    | '+' list {$$ = sum_list($2);}
    | '*' list {$$ = prod_list($2);}
    | '-' expr {$$ = - $2;}
    | expr {$$ = $1;}
    ;

list: expr {$$ = make_list($1);}
    | list expr {$$ = extend_list($1, $2);}
    ;

%%

int main()
{
  yyparse();
}

void yyerror(const char* s)
{
  fprintf(stderr, "%s\n", s);
}

List* make_list(double v)
{
  List* ret = malloc(sizeof(List));
  ret->size = 1;
  ret->p = malloc(ret->size * sizeof(double));
  ret->p[0] = v;
  return ret;
}

List* extend_list(List* l, double v)
{
  List* ret = malloc(sizeof(List));
  ret->size = l->size + 1;
  ret->p = malloc(ret->size * sizeof(double));
  for (size_t i = 0; i != l->size; ++i){
    ret->p[i] = l->p[i];
  }
  ret->p[l->size] = v;
  
  free(l->p);
  free(l);

  return ret;
}

double sum_list(List* l)
{
  double sum = 0;
  for (size_t i = 0; i != l->size; ++i){
    sum += l->p[i];
  }
  free(l->p);
  free(l);
  return sum;
}

double prod_list(List* l)
{
  double prod = 1;
  for (size_t i = 0; i != l->size; ++i){
    prod *= l->p[i];
  }
  free(l->p);
  free(l);
  return prod;
}
