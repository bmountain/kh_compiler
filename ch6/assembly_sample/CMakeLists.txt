add_executable(assembly_sample
main.c
)

target_link_libraries(
  assembly_sample
  PRIVATE
  vsm_calcl
)

target_include_directories(
  assembly_sample
  PRIVATE
  ${CMAKE_CURRENT_SOURCE_DIR}/../vsm
)