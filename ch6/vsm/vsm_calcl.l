%{
#include "y.tab.h"
#include "vsm_calcl.h"
#include <stdio.h>
#include <ctype.h>
int SkipComment(void);
int to_address(char c);
%}

%option noyywrap

ws [ \t\n]
symbol [();]
digit [0-9]
alpha [a-zA-Z]
other .

%%

{ws}+ 
{symbol} {return yytext[0];}
"+" {yylval = ADD; return ADDOP;}
"-" {yylval = SUB; return ADDOP;}
"*" {yylval = MUL; return MULOP;}
"/" {yylval = DIV; return MULOP;}
"%" {yylval = MOD; return MULOP;}
"=" {return EQUAL;}
{digit}+ {sscanf(yytext, "%d", &yylval); return NUM;}
{alpha} {yylval = to_address(yytext[0]); return VAR;}
"/*" {if (SkipComment() == EOF) return EOF;}
{other} {fprintf(stderr, "Illegal char %c ignored\n", yytext[0]);}

%%

int SkipComment(void)
{
  int c;
  while(1){
    while ((c = input()) != '*' && c != EOF)
      ;
    if (c == '*'){
      while ((c = input()) == '*')
        ;
      if (c == '/')
        return 1;
    }
    if (c == EOF){
      fprintf(stderr, "Unterminated comment\n");
      return EOF;
    }
  }
}

// convert an alphabet to an address
int to_address(char c)
{
  if (islower(c))
    return DSEG_SIZE + 1 + c - 'a';
  else
    return DSEG_SIZE + 1 + c - 'A';
}