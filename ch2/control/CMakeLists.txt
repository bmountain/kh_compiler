bison_target(
  ControlParserBison
  control.y
  control.c
)

add_executable(
  ControlParser
  main.c
  control.c
)