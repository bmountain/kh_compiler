%{
#include <stdio.h> 
#include <stdlib.h> 
#include <ctype.h>
#include <string.h>

typedef struct string {
  char* p;
  size_t size; // 終端文字を含めない
} string;

#define YYSTYPE string

string create_var(const char c);
string create_bin(const char c, string first, string second);
string create_uni(const char c, string first);

int yylex(void);
void yyerror(const char* s);

%}

%left '+' '-'
%left '*' '/'
%right UMINUS
%token VAR

%%

line:
    | line expr '\n' {printf("%s\n", $2.p); free($2.p);}
    ;

expr: expr '+' expr {$$ = create_bin('+', $1, $3);}
    | expr '-' expr {$$ = create_bin('-', $1, $3);}
    | expr '*' expr {$$ = create_bin('*', $1, $3);}
    | expr '/' expr {$$ = create_bin('/', $1, $3);}
    | '(' expr ')' {$$ = $2;}
    | '-' expr %prec UMINUS {$$ = create_uni('-', $2);}
    | VAR {$$ = $1;}
%%

int yylex(void)
{
  int c;
  while((c = getchar()) == ' ')
    ;
  if (islower(c)){
    yylval = create_var(c);
    return VAR;
  } else {
    return c;
  }
}

void yyerror(const char* s)
{
  fprintf(stderr, "%s\n", s);
  exit(1);
}

string create_var(const char c)
{
  string s;
  s.p = malloc(2 * sizeof(char));
  s.p[0] = c;
  s.p[1] = '\0';
  s.size = 1;
  return s;
}

string create_bin(const char c, string first, string second)
{
  string ret;
  ret.size = first.size + second.size + 5; // 括弧2つ・記号1つ・空白2つ
  ret.p = malloc((ret.size + 1) * sizeof(char)); // ヌル文字考慮
  
  ret.p[0] = '(';
  ret.p[1] = c;
  ret.p[2] = ' ';
  memcpy(ret.p + 3, first.p, first.size); // (c <first>
  ret.p[first.size + 3] = ' ';
  memcpy(ret.p + first.size + 4, second.p, second.size);
  ret.p[first.size + second.size + 4] = ')';
  ret.p[ret.size] = '\0';
  
  free(first.p);
  free(second.p);

  return ret;
}

string create_uni(const char c, string first)
{
  string ret;
  ret.size = first.size + 3; // 括弧2つ、記号1つ
  ret.p = malloc((ret.size + 1) * sizeof(char));

  ret.p[0] = '(';
  ret.p[1] = c;
  memcpy(ret.p + 2, first.p, first.size);
  ret.p[first.size + 2] = ')';
  ret.p[ret.size] = '\0';
  free(first.p);

  return ret;
}