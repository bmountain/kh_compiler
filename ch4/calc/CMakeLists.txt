bison_target(
  calcParser
  calc.y
  calc.c
)

add_executable(
  calc3
  calc.c
  main.c
)