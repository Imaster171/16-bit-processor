`timescale 1ns / 1ps
`include "instruction_memory.v"
`include "register_file.v"
`include "alu.v"
`include "program_counter.v"
`include "data_memory.v"

module processor (
    input clk,                      // Clock signal
    input reset,                    // Reset signal
    output [9:0] pc                 // Program counter
);

    // Wires for connecting modules
    wire [15:0] instruction;
    wire [2:0] read_addr1, read_addr2, write_addr;
    wire [15:0] read_data1, read_data2, write_data;
    wire [2:0] opcode;
    wire write_enable;
    wire [15:0] alu_result;
    wire zero;
    wire [9:0] branch_address;
    wire branch_enable;
    wire mem_write;
    wire mem_read; // Wire for memory read enable
    wire [15:0] mem_address, mem_data, mem_read_data;
    reg [15:0] operand_b;
    reg [9:0] next_pc;

    // Instruction memory instance
    instruction_memory imem (
        .address(pc),               // Program counter as address
        .instruction(instruction)   // Fetched instruction
    );

    // Register file instance
    register_file regfile (
        .clk(clk),
        .reset(reset),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .write_addr(write_addr),
        .write_data(write_data),
        .write_enable(write_enable),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // ALU instance
    alu alu_inst (
        .a(read_data1),
        .b(operand_b),
        .opcode(opcode),
        .result(alu_result),
        .zero(zero)
    );

    // Data memory instance
    data_memory dmem (
        .clk(clk),
        .address(mem_address),
        .write_data(mem_data),
        .mem_write(mem_write),
        .read_data(mem_read_data)
    );

    // Program counter instance
    program_counter pc_inst (
        .clk(clk),
        .reset(reset),
        .branch_enable(branch_enable),
        .branch_address(branch_address),
        .next_pc(next_pc), // Pass next_pc to program_counter
        .pc(pc)
    );

    // Instruction decoding
    assign opcode = instruction[15:13];
    assign read_addr1 = instruction[9:7];
    assign read_addr2 = (opcode == 3'b001 || opcode == 3'b010) ? 3'b000 : instruction[2:0]; // Use 0 for immediate instructions
    assign write_addr = instruction[12:10];
    assign write_data = (opcode == 3'b100) ? pc : 
                        (opcode == 3'b101) ? {instruction[9:0], 6'b0} : // LUI
                        (opcode == 3'b111) ? mem_read_data : // LW
                        alu_result; // Store current PC in rA for JALR or LUI
    assign write_enable = (opcode == 3'b000 || opcode == 3'b001 || opcode == 3'b010 || 
                           (opcode == 3'b100 && instruction[6:0] == 7'b0000000) || opcode == 3'b101 || opcode == 3'b111); // ADD, ADDI, SUBI, JALR, LUI, LW

    // Memory write enable logic (SW instruction)
    assign mem_write = (opcode == 3'b110); // SW
    assign mem_read = (opcode == 3'b111); // LW
    assign mem_address = read_data1 + {{9{instruction[6]}}, instruction[6:0]}; // Address calculation for SW and LW
    assign mem_data = regfile.reg_file[write_addr]; // Data to be stored in memory for SW

    // Branch enable logic
    assign branch_enable = (opcode == 3'b011) && (regfile.reg_file[instruction[12:10]] == regfile.reg_file[instruction[9:7]]); // BEQ
    assign branch_address = branch_enable ? {{3{instruction[6]}}, instruction[6:0]} : 10'b0; // Sign-extended immediate value for BEQ or zero if not branching

    // Operand B selection
    always @(*) begin
        case (opcode)
            3'b001: operand_b = {{12{instruction[3]}}, instruction[3:0]}; // Sign-extended ADDI
            3'b010: operand_b = {{12{instruction[3]}}, instruction[3:0]}; // Sign-extended SUBI
            default: operand_b = read_data2; // Default to read_data2 for other instructions
        endcase
    end

    // JALR logic
    always @(*) begin
        if (opcode == 3'b100) begin
            next_pc = regfile.reg_file[read_addr1]; // Set next PC to the value in rB
        end else begin
            next_pc = pc + 1; // Default to incrementing PCs
        end
    end

endmodule