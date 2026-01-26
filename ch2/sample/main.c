#include <stdio.h>

// bisonが生成するソースファイルにyyparseがある
int yyparse(void);

int main(void)
{
  yyparse();
}