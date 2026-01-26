%{
#include <stdlib.h>
#include <stdio.h>
int yylex(void);
void yyerror(const char*s );
%}

%%

input : octal '\n' {printf(" is octal\n");} 
      | float '\n' {printf(" is float\n");}

octal : '0' octal_integer ;
octal_integer : octal_digit | octal_integer octal_digit ;
octal_digit : '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' ;
      
float: number '.' number | number '.' zero_starting_number | '0' '.' zero_starting_number | '0' '.' number;
zero_starting_number : '0' zero_starting_number | '0';
number: posdigit | number digit ;
posdigit :  '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9' ;
digit : '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9' ;

%%

int yylex(void)
{
  int c = getchar();
  if (c != ' ' && c != '\n')
    printf("%c", c);
  return c;
}

void yyerror(const char* s)
{
  fprintf(stderr, "%s\n", s);
}