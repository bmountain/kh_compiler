/**
 * When Lexer read a symbol (name of variable), it register to a name table.
 * The name table guarantees that a symbol is always represented by the same pointer.
 * The name table will be implemented as a chain-method hash table.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct ID_entry
{
  char* name_ptr;
  int len;
  struct ID_entry* next;
} ID_entry;

#define IDT_SIZE 113
static ID_entry* IDtable[IDT_SIZE];

static int hash(char*);

// search a symbol and register
char* IDentry(char* sp, int len)
{
  int hval = hash(sp);
  ID_entry* np;
  for (np = IDtable[hval]; np; np = np->next) {
    if (np->len == len && strcmp(np->name_ptr, sp) == 0) {
      return np->name_ptr;
    }
  }
  np = (ID_entry*)malloc(sizeof(ID_entry));
  np->name_ptr = strdup(sp);
  np->len = len;
  np->next = IDtable[hval];
  IDtable[hval] = np;
  return np->name_ptr;
}

// hash function
static int hash(char* sp)
{
  unsigned h, g;
  for (h = 0; *sp != '\0'; ++sp) {
    h = (h << 4) + (unsigned)(*sp);
    if ((g = h & 0xf0000000))
      h = (h ^ g >> 24) ^ g;
  }
  return (h % IDT_SIZE);
}