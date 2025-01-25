`timescale 1ns / 1ps

`include "instruction_memory.v"
`include "register_file.v"
`include "alu.v"
`include "program_counter.v"
`include "data_memory.v"

module processor (
    input clk,
    input reset,
    output [9:0] pc
);

    // Wires for connecting modules
    wire [15:0] instruction;
    wire [2:0] reg_b, reg_c, reg_a;
    wire [6:0] imm;
    wire [9:0] imm10;
    wire [15:0] reg_b_data, reg_c_data, reg_a_data, write_data, read_data;
    wire [2:0] opcode;
    wire write_enable;
    wire [15:0] alu_result;
    wire zero;
    wire [9:0] branch_address;
    wire branch_enable;
    wire mem_write;
    wire mem_read;
    wire [15:0] mem_address, mem_data, mem_read_data;
    reg [9:0] next_pc;

    // Instruction memory instance
    instruction_memory imem (
        .address(pc),
        .instruction(instruction)
    );

    // Register file instance
    register_file regfile (
        .clk(clk),
        .reset(reset),
        .read_addr1(reg_b),
        .read_addr2((opcode == 3'b011 || opcode == 3'b110) ? reg_a : reg_c),
        .write_addr(reg_a),
        .write_data(write_data),
        .write_enable(write_enable),
        .read_data1(reg_b_data),
        .read_data2(read_data)
    );

    // ALU instance
    alu alu_inst (
        .a(reg_b_data),
        .b((opcode == 3'b001 || opcode == 3'b010) ? {{9{imm[6]}}, imm} : reg_c_data),
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
        .next_pc(next_pc),
        .pc(pc)
    );

    // Instruction Decoding
    // ====================
    // This section handles the extraction of instruction fields and the decoding logic
    // for determining the control signals and data paths based on the opcode and other
    // instruction fields.

    // Instruction Fields Extraction
    assign opcode = instruction[15:13];
    assign reg_a = instruction[12:10];
    assign reg_b = instruction[9:7];
    assign reg_c = instruction[2:0];
    assign imm = instruction[6:0];
    assign imm10 = instruction[9:0];

    // Register-related assignments
    assign write_enable = (opcode != 3'b110 && opcode != 3'b011); // True for all except BEQ and SW
    assign write_data = (opcode == 3'b100) ? pc :                 // JALR: Store current PC
                        (opcode == 3'b101) ? {imm10, 6'b0} :      // LUI: Stores upper immediate
                        (opcode == 3'b111) ? mem_read_data :      // LW: Stores word from memory
                        alu_result;                               // Default: Stores result from ALU

    assign reg_a_data = (opcode == 3'b110 || opcode == 3'b011) ? read_data : 16'bz;
    assign reg_c_data = (opcode != 3'b110 && opcode != 3'b011) ? read_data : 16'bz;

    // Memory-related assignments
    assign mem_write = (opcode == 3'b110);                        // SW: Enable memory write
    assign mem_read = (opcode == 3'b111);                         // LW: Enable memory read
    assign mem_address = reg_b_data + {{9{imm[6]}}, imm};         // Calculate memory address for SW and LW
    assign mem_data = reg_a_data;                                 // Data to be stored in memory for SW

    // Branching logic for BEQ and JALR
    always @(*) begin
        case (opcode)
            3'b100: next_pc = reg_b_data;                         // JALR: Jump to the address in register b 
            3'b011: next_pc = (reg_b_data == reg_a_data)          // BEQ: Branch to immediate if reg_a equals reg_b
                            ? pc + {{3{imm[6]}}, imm} 
                            : pc + 1;                                    
            default: 
                next_pc = pc + 1;
        endcase
    end

endmodule