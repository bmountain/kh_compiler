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
{digit}+ {sscanf(yytext, "%d", &yylval.ival);
          return INTC;
         }
{digit}+"."{digit}* {sscanf(yytext, "%lf", &yylval.rval);
                     return REALC;
                    }
{other} {fprintf(stderr, "Illegal char %c ignored.\n", yytext[0]);}


%%