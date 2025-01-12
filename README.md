# 16-bit Processor

This project implements a 16-bit processor with basic arithmetic operations (ADD, SUB, ADDI, SUBI). The processor includes an instruction memory, register file, and ALU.

## Directory Structure

```
16-bit-processor/
├── src/
│   ├── alu.v
│   ├── instruction_memory.v
│   ├── processor.v
│   ├── processor_tb.v
│   ├── register_file.v
│   ├── program_counter.v
│   ├── program_memory.v
├── Makefile
└── README.md
```

## Files

- `src/alu.v`: Arithmetic Logic Unit (ALU) for performing arithmetic operations.
- `src/instruction_memory.v`: Instruction memory to store and fetch instructions.
- `src/processor.v`: Main processor module that integrates the instruction memory, register file, and ALU.
- `src/processor_tb.v`: Testbench for the processor.
- `src/register_file.v`: Register file to store and load values from registers.
- `src/program_counter.v`: Program counter to keep track of the current instruction.
- `src/program_memory.v`: Program memory to store the program instructions.
- `Makefile`: Makefile to compile and run the testbench.
- `README.md`: This file.

## Overview

The 16-bit processor is designed to execute basic arithmetic operations such as ADD, SUB, ADDI, and SUBI. The processor consists of several components:

- **Instruction Memory**: Stores the instructions to be executed by the processor.
- **Register File**: Contains 8 registers, each 16 bits wide, to store intermediate values.
- **ALU (Arithmetic Logic Unit)**: Performs arithmetic operations on the operands.
- **Program Counter**: Keeps track of the current instruction being executed.

### Block Diagram

![Processor Block Diagram](https://example.com/processor_block_diagram.png)

## Instructions

### Compile the Project

To compile the project, run the following command:

```sh
make compile
```

### Run the Testbench

To run the testbench, run the following command:

```sh
make run
```

### Clean the Project

To clean the compiled files, run the following command:

```sh
make clean
```

## How It Works

1. **Instruction Fetch**: The program counter (PC) provides the address to the instruction memory, which fetches the instruction to be executed.
2. **Instruction Decode**: The instruction is decoded to determine the operation (opcode) and the registers involved.
3. **Operand Fetch**: The register file provides the operands for the ALU based on the decoded instruction.
4. **Execute**: The ALU performs the arithmetic operation specified by the opcode.
5. **Write Back**: The result of the ALU operation is written back to the register file.
6. **Update PC**: The program counter is updated to point to the next instruction.

## Example Output

The testbench will display the state of the processor, including the program counter, instruction, opcode, register addresses, register values, and ALU result.

```
Time: 20 | PC: 1 | Instruction: 0100110000000110 | Opcode: 010 | ReadAddr1: 0 | ReadAddr2: 0 | WriteAddr: 3 | ReadData1: 0 | ReadData2: 0 | ALUResult: 6 | WriteEnable: 1
Registers: r0: 0 | r1: 0 | r2: 0 | r3: 6 | r4: 0 | r5: 0 | r6: 0 | r7: 0
...
```

## License

This project is not licensed.
