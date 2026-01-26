bison_target(
  calcParser
  calc.y
  calc.c
)

add_executable(
  calc
  main.c
  calc.c
)