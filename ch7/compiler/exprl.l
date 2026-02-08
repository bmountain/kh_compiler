%{
#include "y.tab.h"
#include "vsm_exprl.h"
#include <stdio.h>
#include <ctype.h>

char* IDentry(char*, int);
%}

%option noyywrap

ws [ \t\n]
symbol [=?!(),:;]
digit [0-9]
letter [a-zA-Z_]
id {letter}({letter}|{digit})*
other .

%%

{ws}+
{symbol} {return yytext[0];}
"+" {yylval.Int = ADD; return ADDOP;}
"-" {yylval.Int = SUB; return ADDOP;}
"*" {yylval.Int = MUL; return MULOP;}
"/" {yylval.Int = DIV; return MULOP;}
"%" {yylval.Int = MOD; return MULOP;}
"++" {yylval.Int = INC; return PPMM;}
"--" {yylval.Int = DEC; return PPMM;}
"&&" {return LAND;}
"||" {return LOR;}
"<" {yylval.Int = BLT; return RELOP;}
"<=" {yylval.Int = BLE; return RELOP;}
">" {yylval.Int = BGT; return RELOP;}
">=" {yylval.Int = BGE; return RELOP;}
"==" {yylval.Int = BEQ; return RELOP;}
"!=" {yylval.Int = BNE; return RELOP;}
"int" {return TYPE;}
"read" {return READ;}
"write" {return WRITE;}
{digit}+ {yylval.Int = atoi(yytext); return NUM;}
{id} {yylval.Name = IDentry(yytext, yyleng); return ID;}
{other} {fprintf(stderr, "Illegal character %c. Ignored.\n", yytext[0]);}

%%
