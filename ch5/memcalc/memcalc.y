%{
#include <math.h>
#include <stdio.h>
#include <string.h>

#define M_SIZE 16
#define VAR_NAME_LIMIT 10

int yyparse(void);
void yyerror(const char* s);
int yylex(void);

typedef struct Variable {
  const char* name;
  double value;
} Variable;

Variable* ref(const char* varname);
Variable* addVar(const char* varname);
void printVarList();

size_t numVariable = 0;
Variable Memory[M_SIZE];

%}

%union{
  int ival;
  double rval;
  const char* cval;
}

// command
%token LIST

// token
%token EXP LOG SQRT INCREMENT DECREMENT
%token <ival> INTC
%token <rval> REALC
%token <cval> VAR

%type <cval> var
%type <rval> expr

%right '=' ADDEQ SUBEQ MULEQ DIVEQ
%left '+' '-'
%left '*' '/'
%right '^'
%right PREFIX
%left POSTFIX
%right UMINUS

%%

line :
     | line expr '\n' {printf("%f\n", $2); }
     | line LIST '\n' {printVarList();}
     | line error '\n' {yyerrok;}
     ;

expr : var '=' expr {$$ = ref($1)->value = $3;}
     | var ADDEQ expr {$$ += $3;}
     | var SUBEQ expr {$$ -= $3;}
     | var MULEQ expr {$$ *= $3;}
     | var DIVEQ expr {$$ /= $3;}
     | expr '+' expr {$$ = $1 + $3;}
     | expr '-' expr {$$ = $1 - $3;}
     | expr '*' expr {$$ = $1 * $3;}
     | expr '/' expr {$$ = $1 / $3;}
     | expr '^' expr {$$ = pow($1, $3);}
     | '-' expr %prec UMINUS {$$ = - $2;}
     | INCREMENT var %prec PREFIX {$$ = ref($2)->value += 1;}
     | DECREMENT var %prec PREFIX {$$ = ref($2)->value -= 1;}
     | var INCREMENT %prec POSTFIX {$$ = ref($1)->value; ref($1)->value += 1;}
     | var DECREMENT %prec POSTFIX {$$ = ref($1)->value; ref($1)->value -= 1;}
     | '(' expr ')' {$$ = $2;}
     | LOG '(' expr ')' {$$ = log($3);}
     | EXP '(' expr ')' {$$ = exp($3);}
     | SQRT '(' expr ')' {$$ = sqrt($3);}
     | var {$$ = ref($1)->value;}
     | INTC {$$ = (double) $1;}
     | REALC {$$ = $1;}
     ;

var : VAR {
  $$ = ref($1)->name;
}
      ;

%%

int main() {
  yyparse();
}

void yyerror(const char* s)
{
  fprintf(stderr, "%s\n", s);
}

Variable* ref(const char* varname)
{
  for (size_t i = 0; i != numVariable; ++i){
    if (strcmp(Memory[i].name, varname)){
      continue;
    } else {
      return &Memory[i];
    }
  }
  
  return addVar(varname);
}

Variable* addVar(const char* varname){
  if (numVariable >= M_SIZE){
    fprintf(stderr, "no enough memory.\n");
    return NULL;
  }
  Memory[numVariable].name = strdup(varname);
  Memory[numVariable].value = 0;
  return &Memory[numVariable++];
}

void divider(int length)
{
  for (size_t i = 0; i != length; ++i){
    printf("-");
  }
}

void printVarList()
{
  const int l = 5;
  const char* message = " Variable List ";
  divider(l);
  printf("%s", message);
  divider(l);
  printf("\n");
  for (size_t i = 0; i != numVariable; ++i){
    Variable* var = &Memory[i];
    printf("%s = %f\n", var->name, var->value);
  }
  divider(2 * l + strlen(message));
  printf("\n");
}