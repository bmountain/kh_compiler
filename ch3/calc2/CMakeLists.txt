bison_target(
  calcParser2
  calc2.y
  calc2.c
)

add_executable(
  calc2
  main.c
  calc2.c
)