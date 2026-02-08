%{
#include "vsm_exprl.h"
#include "main.h"
#include <stdio.h>
int yylex(void);
void yyerror(char* msg);

void SymDecl(const char*);
int SymRef(const char*);
%}

%union {
  int Int;
  char* Name;
}

%token TYPE READ WRITE
%token <Int> ADDOP MULOP PPMM RELOP NUM
%token <Name> ID

%type <Name> LHS

%right ASSIGN
%right <Int> CASSIGN
%right '?' ':'
%left LOR
%left LAND
%left RELOP // comparison
%left ADDOP
%left MULOP
%right '!' PPMM UM
%left POSOP // postfix increment/decrement

%%

program : sentence_list {Pout(HALT);}
        ;

sentence_list: sentence
            | sentence_list sentence
            ;

sentence: decl_list 
        | stmt
        | ';'
        ;

decl_list : decl ';'
          ;

decl : TYPE ID {SymDecl($2);}
    | decl ',' ID {SymDecl($3);}
    ;

stmt : expr ';' {Pout(REMOVE);} // discard return value of expr
     | READ read_list ';' 
     | WRITE write_list ';'
     | error ';' {yyerrok;}
     ;

read_list: LHS {Pout(INPUT);}
         | read_list ',' LHS {Pout(INPUT);}
         ;

write_list: LHS {Cout(PUSH, SymRef($1)); Pout(OUTPUT);}
          | write_list ',' LHS {Cout(PUSH, SymRef($3)); Pout(OUTPUT);}
          ;
     
LHS : ID {Cout(PUSHI, SymRef($1)); $$ = $1;} // put address of ID
    ;

expr : LHS ASSIGN expr {Pout(ASSGN);}
     | LHS CASSIGN { Cout(PUSH, SymRef($1)); } expr {Pout($2); Pout(ASSGN);}
     | expr '?' {$<Int>$ = PC(); Cout(BEQ, -1);} // if <top of stack> != 0, jump to the instruction of expr3
       expr ':' {$<Int>$ = PC(); Cout(JUMP, -1); Bpatch($<Int>3, PC());} // after expr3, jump to the instruction after expr3. back patch BEQ address with expr3
       expr {Bpatch($<Int>6, PC());} // back patch JUMP with the instruction after expr3
     | expr LOR expr {Pout(OR);}
     | expr LAND expr {Pout(AND);}
     | expr RELOP expr {
        Pout(COMP); // compare Stack[PC - 1] with Stack[PC], and put the result
        Cout($2, PC() + 3); // if relation holds, jump to the third next instruction
        Cout(PUSHI,0); // relation does not hold and so put 0
        Cout(JUMP, PC( ) +2); // skip putting 1
        Cout(PUSHI, 1); // realtion holds and so put 1
      }
     | expr ADDOP expr {Pout($2);}
     | expr MULOP expr {Pout($2);}
     | '(' expr ')'
     | '!'expr {Pout(NOT);}
     | ADDOP expr %prec UM {if ($1 == SUB) Pout(CSIGN);}
     | PPMM ID {
        int addr = SymRef($2);
        Cout(PUSH, addr); // put the original value
        Pout($1); // apply the operation
        Pout(COPY); // copy for return value
        Cout(POP, addr); // update the value
     }
     | ID PPMM %prec POSOP {
      int addr = SymRef($1);
      Cout(PUSH, addr);
      Pout(COPY); // copy the original value for return value
      Pout($2); // increment/decrement
      Cout(POP, addr); // update the value
     }
     | ID {Cout(PUSH, SymRef($1));} 
     | NUM {Cout(PUSHI, $1);}
     ;

%%
