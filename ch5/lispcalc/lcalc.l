%{
#include "y.tab.h"
#include <stdio.h>
%}

%option noyywrap

ws[ \t]
symbol [-+*/()\n]
digit [0-9]
integer {digit}+
real {digit}+"."{digit}*
other .

%%

{ws}+
{symbol} {return yytext[0];}
{integer} {sscanf(yytext, "%d", &yylval.ival); return INTC;}
{real} {sscanf(yytext, "%lf", &yylval.rval); return REALC;}
"exp" {return EXP;}
"log" {return LOG;}
"sqrt" {return SQRT;}
{other} {printf("warning: invalid character %c\n", yytext[0]);}

%%