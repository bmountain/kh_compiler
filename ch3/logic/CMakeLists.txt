bison_target(
  logicParser
  logic.y
  logic.c
)

add_executable(
  logic
  logic.c
  main.c
)