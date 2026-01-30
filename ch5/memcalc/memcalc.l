%{
  #include "y.tab.h"
  #include <stdio.h>
%}

%option noyywrap

ws [ \t]
symbol [-+=*/\^[\]\n()]
alpha [a-zA-Z]
alnum [a-zA-Z0-9]
var {alpha}{alnum}*
digit [0-9]
integer {digit}+
real {digit}+"."{digit}*
other .

%%

{ws}+
"list" {return LIST;}
"++" {return INCREMENT;}
"--" {return DECREMENT;}
"+=" {return ADDEQ;}
"-=" {return SUBEQ;}
"*=" {return MULEQ;}
"/=" {return DIVEQ;}
{symbol} {return yytext[0];}
"exp" {return EXP;}
"log" {return LOG;}
"sqrt" {return SQRT;}
{var} {yylval.cval = yytext; return VAR;}
{integer}"K" {
  sscanf(yytext, "%dK", &yylval.ival);
  yylval.ival = 1000 * yylval.ival;
  return INTC;
}
{integer}"M" {
  sscanf(yytext, "%dM", &yylval.ival);
  yylval.ival = 1000000 * yylval.ival;
  return INTC;
}
{integer}"G" {
  sscanf(yytext, "%dG", &yylval.ival);
  yylval.ival = 1000000000 * yylval.ival;
  return INTC;
}
{integer} {sscanf(yytext, "%d", &yylval.ival);
          return INTC;
         }
{real} {sscanf(yytext, "%lf", &yylval.rval);
                     return REALC;
                    }
{other} {fprintf(stderr, "Illegal char %c ignored.\n", yytext[0]);}


%%