bison_target(
  Parser
  assignment.y
  assignment.c
)

add_executable(
  AssignParser
  main.c
  assignment.c
)