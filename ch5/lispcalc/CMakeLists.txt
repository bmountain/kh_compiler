bison_target(
  lispCalcParser
  lcalc.y
  y.tab.c
  DEFINES_FILE y.tab.h
  OPTIONS -Wcounterexamples
)

flex_target(
  lispCalcLexer
  lcalc.l
  lex.yy.c
)

add_executable(
  lcalc
  ${CMAKE_CURRENT_BINARY_DIR}/y.tab.c
  ${CMAKE_CURRENT_BINARY_DIR}/lex.yy.c
)

target_link_libraries(
  lcalc
  m
)

target_include_directories(
  lcalc
  PRIVATE
  ${CMAKE_CURRENT_SOURCE_DIR}
)