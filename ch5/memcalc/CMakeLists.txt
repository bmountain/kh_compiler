bison_target(
  mcalcParser
  memcalc.y
  y.tab.c
  DEFINES_FILE y.tab.h
  OPTIONS -Wcounterexamples
)

flex_target(
  mcalcLexer
  memcalc.l
  lex.yy.c
)

add_executable(
  memcalc
  ${CMAKE_CURRENT_BINARY_DIR}/y.tab.c
  ${CMAKE_CURRENT_BINARY_DIR}/lex.yy.c
)

target_link_libraries(
  memcalc
  PRIVATE
  m
)