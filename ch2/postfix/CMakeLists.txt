bison_target(
  Parser
  expr.y
  expr.c
)

add_executable(ToPostfix
main.c
expr.c
)