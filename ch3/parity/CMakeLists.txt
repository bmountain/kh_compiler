bison_target(
  parityParser
  parity.y
  parity.c
)

add_executable(
  parity
  parity.c
  main.c
)