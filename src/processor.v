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
    wire branch;
    wire [9:0] branch_address;

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
        .branch(branch),
        .branch_address(branch_address),
        .pc(pc)
    );

    // Instruction decoding
    assign opcode = instruction[15:13];
    assign read_addr1 = instruction[9:7];
    assign read_addr2 = (opcode == 3'b010 || opcode == 3'b011) ? 3'b000 : instruction[2:0]; // Use 0 for immediate instructions
    assign write_addr = instruction[12:10];
    assign write_data = alu_result;
    assign write_enable = (opcode == 3'b000 || opcode == 3'b001 || opcode == 3'b010 || opcode == 3'b011); // ADD, SUB, ADDI, SUBI

    // Operand B selection
    always @(*) begin
        case (opcode)
            3'b010: operand_b = {12'b0, instruction[3:0]}; // ADDI
            3'b011: operand_b = {12'b0, instruction[3:0]}; // SUBI
            default: operand_b = read_data2; // Default to read_data2 for other instructions
        endcase
    end

   // Branch logic (example, not implemented)
   //assign branch = (opcode == 3'b100); // Example branch condition
   //assign branch_address = read_data1[9:0]; // Example branch address

endmodule