bison_target(
  prefixParser
  prefix.y
  prefix.c
)

add_executable(
  prefix
  prefix.c
  main.c
)