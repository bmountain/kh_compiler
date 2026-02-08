bison_target(
  ExprlParser
  compiler/exprl.y
  ${CMAKE_CURRENT_BINARY_DIR}/y.tab.c
  DEFINES_FILE y.tab.h
  OPTIONS -Wcounterexamples
)

flex_target(
  ExprlLexer
  compiler/exprl.l
  ${CMAKE_CURRENT_BINARY_DIR}/lex.yy.c
)

set(TARGET Exprl)

add_executable(
  ${TARGET}
  ${CMAKE_CURRENT_BINARY_DIR}/y.tab.c
  ${CMAKE_CURRENT_BINARY_DIR}/lex.yy.c
  compiler/NameTable.c
  compiler/SymTable.c
  vsm/main.c
  vsm/vsm_exprl.c
)

target_include_directories(
  ${TARGET}
  PRIVATE
  ${CMAKE_CURRENT_BINARY_DIR}
  ${CMAKE_CURRENT_SOURCE_DIR}/vsm
)