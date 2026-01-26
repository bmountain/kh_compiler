# bison -y expr.y
# gcc y.tab.c main.c -o ExprParser

bison_target(
  Parser
  expr.y # 入力
  expr.c # 出力
)

add_executable(ExprParser
main.c
expr.c # bison_targetコマンドにより生成
)