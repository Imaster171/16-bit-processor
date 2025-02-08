# RISC-V 16-bit Processor on FPGA

## Overview
This project implements a 16-bit RISC-V processor on an FPGA, capable of executing basic arithmetic operations like addition and subtraction. The processor includes an ALU, instruction memory, data memory, register file, and program counter.

### Supported Instructions
- **ADD**: Add
- **ADDI**: Add immediate
- **SUBI**: Subtract immediate
- **BEQ**: Branch if equal
- **JALR**: Jump and link register
- **LUI**: Load upper immediate
- **SW**: Store word
- **LW**: Load word

## Processor Block Diagram
![Processor Block Diagram](docs/processor_block_diagram.png)

## Modules
- **Program Counter (PC)**: Tracks the address of the next instruction.
- **Instruction Memory**: Stores machine code instructions.
- **Register File**: Contains 8 general-purpose 16-bit registers.
- **Arithmetic Logic Unit (ALU)**: Performs arithmetic and logical operations.
- **Data Memory**: Stores and retrieves data during execution.

## Vivado Implementation
The design is implemented using AMD Vivado. The `dual_port_axi_instr_mem` module connects the RISC-V processor with the ARM processor's Python environment, enabling communication and real-time instruction transfer. A Python-based interface allows users to upload files through Jupyter notebooks. This interface facilitates memory access and processor state monitoring.

## Testing
Testbenches were developed for each module to validate operations and ensure consistency with design specifications.

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

## Contributions
- **Ilia Panayotov**: Verilog implementation, diagram design, presentation preparation.
- **Esra Mehmedova**: Verilog implementation, paper review.
- **Esin Mehmedova**: Writing sections 1, 2, and 3 of the paper.
- **Paul Hagner**: Writing sections 4, 5, and 6 of the paper.
- **Yigit Ilk**: Vivado implementation.

## References
1. [Verilog Code for 16-bit RISC Processor](https://www.fpga4student.com/2017/04/verilog-code-for-16-bit-risc-processor.html)
2. [MIPS Store Word (SW) vs Load Word (LW)](https://www.alpharithms.com/mips-store-word-sw-vs-load-word-lw-475521/)
3. [RISC-V Reference Card](https://ic.unicamp.br/~edson/disciplinas/mc404/material-riscv/extra/RISC-V-refcard.pdf)
4. GitHub Copilot was used to assist in the Verilog implementation. [GitHub Copilot](https://github.com/features/copilot)

