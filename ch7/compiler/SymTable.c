#include "main.h"
#include <stdio.h>

#define ST_SIZE 100 // size of symbol table
static char* SymTab[ST_SIZE];
static int Last = 0;

/**
 * @brief add a symbol to the symbol table
 * @param sptr pointer to symbol
 */
void SymDecl(char* sptr)
{
  int i;
  SymTab[Last + 1] = sptr;
  for (i = 1; SymTab[i] != sptr; ++i)
    ;
  if (i <= Last) {
    yyerror("Duplicated declaration.");
  } else {
    ++Last;
  }
}

/**
 * @brief reference a symbol in the symbol table
 * @param sptr pointer to symbol
 * @retval index of the symbol in the symbol table
 */
int SymRef(char* sptr)
{
  int i;
  SymTab[Last + 1] = sptr;
  for (i = 1; SymTab[i] != sptr; ++i)
    ;
  if (i > Last) {
    yyerror("Undeclared symbol.");
  } else {
    return i;
  }
}