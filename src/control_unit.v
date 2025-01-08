`include "instruction_decoder.v"
`include "register_file.v"
`include "alu.v"

module control_unit (
    input clk,
    input reset
);
    // ...existing code...

    // Instruction ROM
    reg [15:0] instruction_rom [0:31];
    reg [4:0] pc; // Program counter

    // Wires for connecting modules
    wire [15:0] instruction;
    wire [2:0] alu_op;
    wire reg_write, mem_read, mem_write, branch, jump;
    wire [15:0] alu_result, read_data1, read_data2, write_data;
    wire zero;

    // Fetch instruction
    assign instruction = instruction_rom[pc];

    // Instantiate instruction decoder
    instruction_decoder id (
        .instruction(instruction),
        .alu_op(alu_op),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .branch(branch),
        .jump(jump)
    );

    // Instantiate register file
    register_file rf (
        .clk(clk),
        .reset(reset),
        .read_addr1(instruction[12:10]),
        .read_addr2(instruction[9:7]),
        .write_addr(instruction[6:4]),
        .write_data(write_data),
        .write_enable(reg_write),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // Instantiate ALU
    alu alu_inst (
        .a(read_data1),
        .b(read_data2),
        .opcode(alu_op),
        .result(alu_result),
        .zero(zero)
    );

    // Write-back stage
    assign write_data = alu_result;

    // Program counter update
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 0;
        end else if (branch && zero) begin
            pc <= pc + instruction[6:0]; // Branch offset
        end else if (jump) begin
            pc <= read_data1; // Jump address
        end else begin
            pc <= pc + 1;
        end
    end

endmodule
