bison_target(
  tacParser
  three.y
  three.c
)

add_executable(
  tac
  main.c
  three.c
)