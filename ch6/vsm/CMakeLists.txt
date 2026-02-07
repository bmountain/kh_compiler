add_library(
vsm
vsm.c
)
target_link_directories(
  vsm
  PUBLIC
  ${CMAKE_CURRENT_SOURCE_DIR}
)

bison_target(
  calclParser
  calcl.y
  y.tab.c
  DEFINES_FILE y.tab.h
  OPTIONS -Wcounterexamples
)

flex_target(
  calclLexer
  calcl.l
  lex.yy.c
)

add_executable(
  calcl
  y.tab.c
  lex.yy.c
)

target_include_directories(
  calcl
  PRIVATE
  ${CMAKE_CURRENT_SOURCE_DIR}
  ${CMAKE_CURRENT_BINARY_DIR}
)

message("${CMAKE_CURRENT_BINARY_DIR}")

target_link_libraries(
  calcl
  PRIVATE
  vsm
)
