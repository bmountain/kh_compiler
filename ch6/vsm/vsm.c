#include "vsm.h"
#include <stdio.h>

int DebugSW = 0; // flag to dump assembly

static int Pctr = 0;          // program counter
static int SP = 0;            // stack pointer
static int Freg = 0;          // frame register
static int InsCount = 0;      // count instructions
static int MaxSD = 0;         // count depth of stack
static int MinFR = DSEG_SIZE; // minimum value of frame register
static int MaxPC = 0;         // count instructions in object file
static int CallC = 0;         // count CALL instructions

static INSTR Iseg[ISEG_SIZE];
static int Dseg[DSEG_SIZE];

#define STACK_SIZE 100
static int Stack[STACK_SIZE];

char* Scode[] = {
    "  +",  "  -",   "  *",  "  /",  "  %",  "  -",  " ++",   " --",  "and",   " or",  "not",   "  =",  "copy",   "push",  "push-i", "remove", "pop",
    "comp", "setFR", "++FR", "--FR", "jump", "=0 ?", "!=0 ?", "<0 ?", "<=0 ?", ">0 ?", ">=0 ?", "call", "return", "input", "output", "Nop",    "halt",
};

static void PrintIns(int loc)
{
  int op;
  op = Iseg[loc].Op; // get operation code
  printf("%5d  %-8s ", loc, Scode[op]);
  switch (op) {
  case PUSH:
  case PUSHI:
  case POP:
  case SETFR:
  case INCFR:
  case DECFR:
  case JUMP:
  case BLT:
  case BLE:
  case BEQ:
  case BNE:
  case BGE:
  case BGT:
  case CALL:
    printf("%6d%4s", Iseg[loc].Addr, Iseg[loc].Reg ? "[fp]" : " ");
    break;
  default:
    printf("%10c", ' ');
  }
}

int PC(void)
{
  return Pctr;
}

void SetPC(int Addr)
{
  Pctr = Addr;
}

void SetI(OP OpCode, int F, int Addr)
{
  Iseg[Pctr].Op = OpCode;
  Iseg[Pctr].Reg = F;
  Iseg[Pctr].Addr = Addr;
  if (DebugSW) {
    PrintIns(Pctr);
    printf("\n");
  }
  if (++Pctr > MaxPC) {
    MaxPC = Pctr;
  }
}

void Bpatch(int Loc, int Target)
{
  // rewrite the address part of instruction Loc by Target
  while (Loc >= 0) {
    int p;
    if ((p = Iseg[Loc].Addr) == Loc) {
      printf("Trying to rewrite self address part at loc. %d\n", p);
      return;
    }
    Iseg[Loc].Addr = Target;
    Loc = p;
  }
}

// apply a binary operation OP
#define BINOP(OP)                                                                                                                                    \
  {                                                                                                                                                  \
    Stack[SP - 1] = Stack[SP - 1] OP Stack[SP];                                                                                                      \
    SP--;                                                                                                                                            \
  }

int StartVSM(int StartAddr, int TraceSW)
{
  int addr, op;
  Pctr = StartAddr;
  SP = Freg = 0;

  while (1) {
    if (SP >= STACK_SIZE || SP < 0) {
      fprintf(stderr, "Illegal Stack pointer %d\n", SP);
      return -1;
    }
    op = Iseg[Pctr].Op;
    addr = Iseg[Pctr].Addr;
    if (Iseg[Pctr++].Reg & FP) {
      addr += Freg; // modify address
    }
    InsCount++;
    if (SP > MaxSD) {
      MaxSD = SP;
    }
    if (TraceSW) { // dump instruction
      PrintIns(Pctr - 1);
      printf("%15d %4d %12d\n", addr, SP, Stack[SP]);
    }

    switch (op) {
    case NOP:
      continue;
    case ASSGN:
      addr = Stack[--SP];
      Dseg[addr] = Stack[SP] = Stack[SP + 1];
      continue;
    case ADD:
      BINOP(+);
      continue;
    case SUB:
      BINOP(-);
      continue;
    case MUL:
      BINOP(*);
      continue;
    case DIV:
      if (Stack[SP] == 0) {
        fprintf(stderr, "Zero divider detected\n");
        return -2;
      }
      BINOP(/);
      continue;
    case MOD:
      if (Stack[SP] == 0) {
        fprintf(stderr, "Zero divider detected\n");
        return -2;
      }
      BINOP(%);
      continue;
    case CSIGN:
      Stack[SP] = -Stack[SP];
      continue;
    case AND:
      BINOP(&&);
      continue;
    case OR:
      BINOP(||);
      continue;
    case NOT:
      Stack[SP] = !Stack[SP];
      continue;
    case COMP:
      Stack[SP - 1] = Stack[SP - 1] > Stack[SP] ? 1 : Stack[SP - 1] < Stack[SP] ? -1 : 0;
      --SP;
      continue;
    case COPY:
      ++SP;
      Stack[SP] = Stack[SP - 1];
      continue;
    case PUSH:
      Stack[++SP] = Dseg[addr];
      continue;
    case PUSHI:
      Stack[++SP] = addr;
      continue;
    case REMOVE:
      --SP;
      continue;
    case POP:
      Dseg[addr] = Stack[SP--];
      continue;
    case INC:
      Stack[SP] = ++Stack[SP];
      continue;
    case DEC:
      Stack[SP] = --Stack[SP];
      continue;
    case SETFR:
      Freg = addr;
      continue;
    case INCFR:
      if ((Freg += addr) >= DSEG_SIZE) {
        printf("Freg overflow at loc. %d\n", Pctr - 1);
        return -3;
      }
      continue;
    case DECFR:
      Freg -= addr;
      if (Freg < MinFR) {
        MinFR = Freg;
      }
      continue;
    case JUMP:
      Pctr = addr;
      continue;
    case BLT:
      if (Stack[SP--] < 0) {
        Pctr = addr;
      }
      continue;
    case BLE:
      if (Stack[SP--] <= 0) {
        Pctr = addr;
      }
      continue;
    case BEQ:
      if (Stack[SP--] == 0) {
        Pctr = addr;
      }
      continue;
    case BNE:
      if (Stack[SP--] != 0) {
        Pctr = addr;
      }
      continue;
    case BGT:
      if (Stack[SP--] > 0) {
        Pctr = addr;
      }
      continue;
    case BGE:
      if (Stack[SP--] >= 0) {
        Pctr = addr;
      }
      continue;
    case CALL:
      Stack[++SP] = Pctr;
      Pctr = addr;
      CallC++;
      continue;
    case RET:
      Pctr = Stack[SP--];
      continue;
    case HALT:
      return 0;
    case INPUT:
      scanf("%d\n", &Dseg[Stack[SP--]]);
      continue;
    case OUTPUT:
      printf("%15d\n", Stack[SP--]);
      continue;
    default:
      printf("Illegal Op. code at location %d\n", Pctr);
      return -4;
    }
  }
}

void DumpIseg(int first, int last)
{
  printf("\nContents of Instructions Segnemnt\n");
  for (; first <= last; ++first) {
    PrintIns(first);
    printf("\n");
  }
  printf("\n");
}

void ExecReport(void)
{
  printf("\nObject Code Size: %10d ins. \n", MaxPC);
  printf("Max Stack Depth: %10d\n", MaxSD);
  printf("Max Frame Size: %10d bytes\n", DSEG_SIZE - MinFR);
  printf("Function calls: %10d times\n", CallC);
  printf("Execution Count: %10d ins. \n\n", InsCount);
}