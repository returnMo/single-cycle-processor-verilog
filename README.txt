Project: 16-bit Single-Cycle Processor (Verilog HDL)
====================================================

1. Overview
-----------
This project implements a simple 16‑bit single‑cycle processor in Verilog HDL.
The design includes a complete datapath and control unit and is verified using
modular testbenches and a final integrated testbench (SingleCycleProcessor_tb).

Main characteristics:
- Architecture : Single-Cycle
- Data width   : 16 bits
- Address width: 12 bits
- Registers    : 8 general purpose registers (R0..R7)
- Special reg  : R0 used as Accumulator
- Instruction Memory: 4096 x 16‑bit (program storage)
- Data Memory        : 4096 x 16‑bit

The instruction set supports memory access (Load/Store), unconditional jump,
conditional branch (BranchZ), register‑type operations, and immediate‑type
operations (Addi/Subi/Andi/Ori).

2. Instruction Formats
----------------------
The processor uses four instruction formats:

Type A:  [15:12] Op, [11:0] Address
   - Used by: Load, Store, Jump

Type B:  [15:12] Op, [11:9] Ri, [8:0] Addr
   - Used by: BranchZ (branch if R0 - Ri == 0)

Type C:  [15:12] Op, [11:9] Ri, [8:0] Funct
   - Used by: register‑type instructions (MoveTo, MoveFrom, Add, Sub, And, Or, Not, Nop)

Type D:  [15:12] Op, [11:0] Imm
   - Used by: immediate‑type instructions (Addi, Subi, Andi, Ori)

3. Instruction Set (behavior)
-----------------------------
Load adr-12      : R0 <- M[adr-12]
Store adr-12     : M[adr-12] <- R0
Jump adr-12      : PC <- adr-12
BranchZ Ri, adr-9: if (R0 - Ri == 0) PC[8:0] <- adr-9

MoveTo Ri        : Ri <- R0
MoveFrom Ri      : R0 <- Ri
Add Ri           : R0 <- R0 + Ri
Sub Ri           : R0 <- R0 - Ri
And Ri           : R0 <- R0 AND Ri
Or Ri            : R0 <- R0 OR  Ri
Not Ri           : R0 <- NOT Ri
Nop              : no operation

Addi Imm-12      : R0 <- R0 + Imm-12
Subi Imm-12      : R0 <- R0 - Imm-12
Andi Imm-12      : R0 <- R0 AND Imm-12
Ori  Imm-12      : R0 <- R0 OR  Imm-12

4. RTL Modules
--------------
- Program Counter (PC): 12‑bit register with synchronous load and reset.
- Instruction Memory : 4K x 16 ROM initialized from "program.hex".
- Data Memory        : 4K x 16 RAM with separate read/write control.
- Register File      : 8 x 16‑bit registers, dual read ports, single write port.
- Extend Unit        : zero‑extend / sign‑extend 12‑bit immediates to 16 bits.
- ALU                : 16‑bit ALU with operations:
                       000: A + B
                       001: A - B
                       010: A AND B
                       011: A OR  B
                       100: NOT A
                       101: pass A
                       110: pass B
- Control Unit       : combinational logic that generates control signals
                       (Jump, Branch, RegWrite, MemRead, MemWrite, MemToReg,
                        ALUSrc, RegDst, ALU_InA_Sel, ExtSel, ALUOp).

5. Testbenches
--------------
For each module a dedicated testbench is provided:
- PC_tb
- InstructionMemory_tb
- DataMemory_tb
- RegisterFile_tb
- ALU_tb
- ExtendUnit_tb
- ControlUnit_tb

The ControlUnit_tb exhaustively checks the control signals for all instruction
types and funct codes using a task `check_ctrl`.

The final integrated testbench:
- SingleCycleProcessor_tb

6. Final Program and Expected Results
-------------------------------------
The final program (program.hex) used in SingleCycleProcessor_tb is:

C005
8201
C003
8401
8202
8404
8208
8601
420C
8210
480C
C001
8220
8240
E00F
F0F0
D00F
1020
CFFF
0020
8A01
4618
4A19
C001
F800
8080
201C
C123
201C

The processor executes the program instruction by instruction and finally
reaches a self-loop at address 0x01C (Jump 0x01C).

At the end of simulation the expected architectural state is:

R0 = 16'h00EB
R1 = 16'h0005
R2 = 16'h0008
R3 = 16'h0008
R4 = 16'h0000
R5 = 16'h00EB
R6 = 16'h0000
R7 = 16'h0000
MEM[0x020] = 16'h00EB
PC  = 12'h01C
IR  = 16'h201C   // Jump 0x01C

The testbench compares these expected values with the actual outputs and
prints "TEST PASSED" when they all match.

7. How to Run
-------------
1. Open the project in your Verilog simulator (e.g., ModelSim / QuestaSim).
2. Compile all RTL files and testbenches.
3. Run "SingleCycleProcessor_tb".
4. Observe the waveform (clk, reset, cycle, expected_* signals) and the
   simulation transcript.
5. Successful execution is indicated by:
   - PC stuck at 0x01C (self-loop),
   - final register/memory values as listed above,
   - message "TEST PASSED" in the transcript.

8. Files
--------
- pc.v, pc_tb.v
- instruction_memory.v, instruction_memory_tb.v
- data_memory.v, data_memory_tb.v
- register_file.v, register_file_tb.v
- alu.v, alu_tb.v
- extend_unit.v, extend_unit_tb.v
- control_unit.v, control_unit_tb.v
- single_cycle_processor.v
- SingleCycleProcessor_tb.v
- program.hex
- README.txt  (this file)
