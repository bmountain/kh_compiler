%{
#include "vsm_calcl.h"
#include <stdio.h>
void yyerror(const char*);
int yylex(void);
%}

%token NUM VAR

%right EQUAL
%left ADDOP
%left MULOP
%right UMINUS

%%

program : expr_list {Pout(HALT);}
        ;

expr_list :
          | expr_list sentence ';' {Pout(OUTPUT);}
          | expr_list error {yyerrok;}
          ;

sentence: expr
        | VAR EQUAL expr { Cout(POP, $1); Cout(PUSH, $1);}
        ;

expr : expr ADDOP expr {Pout($2);}
     | expr MULOP expr {Pout($2);}
     | '(' expr ')'
     | ADDOP expr %prec UMINUS {if ($1 == SUB) Pout(CSIGN);}
     | NUM {Cout(PUSHI, $1);}
     | VAR {Cout(PUSH, $1);}
     ;

%%

#define TraceSW 0

int main()
{
  SetPC(0);
  yyparse();
  DumpIseg(0, PC() - 1);
  printf("Enter execution phase\n");
  if (StartVSM(0, TraceSW) != 0){
    printf("Execution aborted\n");
  }
}

void yyerror(const char* s)
{
  printf("%s\n", s);
}