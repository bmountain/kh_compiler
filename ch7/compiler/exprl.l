%{
#include "y.tab.h"
#include "vsm_exprl.h"
#include <stdio.h>
#include <ctype.h>

char* IDentry(char*, int);
int to_int(const char* s);
%}

%option noyywrap

ws [ \t\n]
symbol [?!(),:;]
digit [0-9]
letter [a-zA-Z_]
id {letter}({letter}|{digit})*
other .

%%

{ws}+
{symbol} {return yytext[0];}
"+=" {yylval.Int = ADD; return CASSIGN;}
"-=" {yylval.Int = SUB; return CASSIGN;}
"*=" {yylval.Int = MUL; return CASSIGN;}
"/=" {yylval.Int = DIV; return CASSIGN;}
"%=" {yylval.Int = MOD; return CASSIGN;}
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
"=" {return ASSIGN;}
"int" {return TYPE;}
"read" {return READ;}
"write" {return WRITE;}
"0"[xX][0-9a-zA-Z]+ {yylval.Int = to_int(yytext); return NUM;}
"0"{digit}+ {yylval.Int = to_int(yytext); return NUM;}
{digit}+ {yylval.Int = atoi(yytext); return NUM;}
{id} {yylval.Name = IDentry(yytext, yyleng); return ID;}
{other} {fprintf(stderr, "Illegal character %c. Ignored.\n", yytext[0]);}

%%

// convert octtal/decimal/hex number to int
int to_int(const char* s)
{
  int c;
  int ret = 0;
  if (s[0] != '0'){ // dec
    return atoi(s);
  }
  if (tolower(s[1]) == 'x'){ // hex
  int i;
  for(i = 2; s[i] != '\0'; ++i){
      c = tolower(s[i]);
        ret *= 16;
      if ('a' <= c && c <= 'z'){
        ret += c - 'a' + 10;
      } else {
        ret += c - '0';
      }
    }
    return ret;
  } else { // octal
    for(int i = 1; s[i] != '\0'; ++i){
      c = tolower(s[i]);
      ret *= 8;
      ret += c - '0';
    }
    return ret;
  }
}