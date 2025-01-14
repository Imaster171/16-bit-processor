`timescale 1ns / 1ps
`include "instruction_memory.v"
`include "register_file.v"
`include "alu.v"
`include "program_counter.v"

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
    reg [15:0] operand_b;
    wire [9:0] branch_address;
    wire branch_enable;
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
    assign write_data = (opcode == 3'b100) ? pc : alu_result; // Store current PC in rA for JALR
    assign write_enable = (opcode == 3'b000 || opcode == 3'b001 || opcode == 3'b010 || (opcode == 3'b100 && instruction[6:0] == 7'b0000000)); // ADD, ADDI, SUBI, JALR

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
            next_pc = pc + 1; // Default to incrementing PC
        end
    end

endmodule