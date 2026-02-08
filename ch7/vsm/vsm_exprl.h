#ifndef VSM__H
#define VSM__H

// operation code
typedef enum
{
  // math
  ADD,
  SUB,
  MUL,
  DIV,
  MOD,
  CSIGN,
  INC,
  DEC,
  // logic
  AND,
  OR,
  NOT,
  // data transfer
  ASSGN,  // assign a value to the address given by the second top of stack, the two top of stack are removed, and the value is placed on stack
  COPY,   // duplicate the top of stack
  PUSH,   // put a value on the stack, where the value comes from the given address of stack
  PUSHI,  // put a value on the stack, where the value is the address part
  REMOVE, // remove the top of stack
  POP,    // move the top of stack to data segment
  // comparison
  COMP, // put -1, 0, 1 when x < y, x = y, x > y, resp.
  // frame register control
  SETFR,
  INCFR,
  DECFR,
  // control
  JUMP, // overwrite program counter
  BEQ,  // compare the top of stack with zero. if they coincide, resume from the instruction in the address part. otherwise, resume from the next
        // instruction.
  BNE,
  BLT,
  BLE,
  BGT,
  BGE,
  CALL, // call function
  RET,  // return from function
  // io
  INPUT,  // transfer value from standard input to data segment
  OUTPUT, // ouptut value in stack to standard output
  // other
  NOP,  // do nothing
  HALT, // stop the program
} OP;

#define ISEG_SIZE 1000               // size of instruction segment
#define DSEG_SIZE 1000               // size of data segment
#define FRAME_BOTTOM (DSEG_SIZE - 1) // last address of data segment

#define FP 0x01 // frame register decoration bit

// instruction
typedef struct
{
  unsigned char Op;  // operation part: defines the type of instruction
  unsigned char Reg; // register part: modifies address
  int Addr;          // address part: defines address
} INSTR;

// operating VSM
void SetPC(int N);                        // set program counter
int PC(void);                             // get program counter
int StartVSM(int StartAddr, int TraceSW); // start virtual stack machine

// handling instructions
void SetI(OP Opcode, int Flag, int Addr); // write instruction
void Bpatch(int Loc, int Addr);           // back-patch address part of instruction
void DumpIseg(int first, int last);       // dump instruction segment
void ExecReport(void);                    // report on execution

#define Cout(OPcode, Addr) SetI(OPcode, 0, Addr) // write instruction with no register part
#define Pout(OPcode) SetI(OPcode, 0, 0)          // write instruction with no register and address part

extern int DebugSW; // control debug output

#endif /* VSM__H */