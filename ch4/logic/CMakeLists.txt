bison_target(
  logicParser
  logic.y
  logic.c
)

add_executable(
  logic2
  logic.c
  main.c
)