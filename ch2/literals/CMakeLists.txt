bison_target(
  Parser
  literals.y
  literals.c
)

add_executable(LiteralParser
  main.c
  literals.c
)