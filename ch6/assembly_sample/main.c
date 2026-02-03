#include "vsm.h"
#include <stdio.h>

#define TraceSW 1
#define X 5
#define Y 10

int main()
{
  // y = x^2 + x/2 の計算
  SetPC(0);
  Cout(PUSHI, X); // アドレスXをスタックに積む [&x]
  Pout(INPUT);    // 標準入力から得た整数をスタック最上段が指定するアドレスに書き込む。この操作のため前段の命令が必要。
  Cout(PUSHI, Y); // アドレスYをスタックに積む [&x, &y]
  Cout(PUSH, X);  // アドレスXの値をスタックに積む [&x, &y, x]
  Pout(COPY);     // スタック最上段の値を複製 [&x, &y, x, x]
  Pout(MUL);      // スタック最上二段の値を掛ける [&x, &y, x^2]
  Cout(PUSH, X);  // アドレスXの値をスタックに積む [&x, &y, x^2, x]
  Cout(PUSHI, 2); // 2をスタックに積む [&x, &y, x^2, x, 2]
  Pout(DIV);      // 二段目を最上段で割る [&x, &y, x^2, x/2]
  Pout(ADD);      // 最上二段を足す [&x, &y, x^2 + x/2]
  Pout(ASSGN);    // [&x, &y, y], where y = x^2 + x/2
  Pout(OUTPUT);   // [&x, &y], yを出力
  Pout(HALT);

  DumpIseg(0, PC() - 1);
  printf("Enter execution phase\n");
  if (StartVSM(0, TraceSW) != 0) {
    printf("Execution aborted\n");
  }
  return 0;
}