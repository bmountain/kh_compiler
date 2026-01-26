bison_target(
  prefixcalcParser
  prefixcalc.y
  prefixcalc.c
)

add_executable(
  prefixcalc
  prefixcalc.c
  main.c
)