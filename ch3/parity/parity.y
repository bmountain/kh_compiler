%{
#include <stdlib.h>
#include <stdio.h>
int yylex(void);
void yyerror(const char*);
%}

%start line;
%token BIT;

%%

line: bits  '\n';
bits : eight_bits {if ($1 %2) {printf("\nOK.\n");} else {printf("\nNG.\n");}}
     | seven_bits {if ($1 % 2) {printf("0\n");} else {printf("1\n");}};
eight_bits : seven_bits BIT {$$ = $1 + $2;};
seven_bits : BIT BIT BIT BIT BIT BIT BIT {$$ = $1 + $2 + $3 + $4 + $5 + $6 + $7;};

%%

int yylex(void)
{
  int c;
  c = getchar();
  if (c == '0' || c == '1'){
    printf("%c", c);
    yylval = c - '0';
    return BIT;
  }
  return c;
}

void yyerror(const char* s)
{
  fprintf(stderr, "%s\n", s);
  exit(1);
}