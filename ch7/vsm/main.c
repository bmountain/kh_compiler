#include "vsm_exprl.h"
#include "y.tab.h"
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int StartP = 0, SymPrintSW = 0;
static int ExecSW = 1, ObjOutSW = 0, TraceSW = 0, StatSW = 0;

static int ErrorC = 0;
static char SourceFile[20];

extern FILE* yyin;
static void SetUpOpt(int, char*[]);

int main(int argc, char* argv[])
{
  SetUpOpt(argc, argv);
  if (SourceFile[0] != '\0') {
    if ((yyin = fopen(SourceFile, "r")) == NULL) {
      fprintf(stderr, "Source file cannot be opend.\n");
      exit(-1);
    }
  }
  yyparse();
  if (ObjOutSW)
    DumpIseg(0, PC() - 1);
  if (ExecSW || TraceSW) {
    if (ErrorC == 0) {
      printf("Enter execution phase\n");
      if (SourceFile[0] == '\0') {
        rewind(stdin);
      }
      if (StartVSM(StartP, TraceSW) != 0) {
        printf("Execution aborted.\n");
      }
      if (StatSW) {
        ExecReport();
      }
    } else {
      printf("Execution suppressed.\n");
    }
  }
}

static void SetUpOpt(int argc, char* argv[])
{
  char* s;
  if (--argc > 0 && (*++argv)[0] == '-') {
    for (s = *argv + 1; *s != '\0'; ++s) {
      switch (tolower(*s)) {
      case 'c':
        StatSW = 1;
        break;
      case 'd':
        DebugSW = 1;
        break;
      case 'n':
        ExecSW = 0;
        break;
      case 'o':
        ObjOutSW = 1;
        break;
      case 's':
        SymPrintSW = 1;
        break;
      case 't':
        TraceSW = 1;
        break;
      }
    }
    --argc;
    ++argv;
  }
  if (argc > 0) {
    strcpy(SourceFile, *argv);
  }
}

void yyerror(char* msg)
{
  extern int yylineno;
  printf("%s at line %d\n", msg, yylineno);
  ErrorC++;
}