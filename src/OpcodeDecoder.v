module instructionDecoder (
    input wire clk,
    input wire [15:0] instruction,
    input wire [15:0] init_values [0:7], // Array to initialize registers
    output wire [15:0] result
);
    wire [2:0] reg1 = instruction[12:10];
    wire [2:0] reg2 = instruction[9:7];
    wire [2:0] reg3 = instruction[6:4];
    wire [15:0] imm = {{9{instruction[6]}}, instruction[6:0]}; // Sign-extend 7-bit immediate
    wire [2:0] opcode = instruction[15:13];

    RegisterFile rf (
        .clk(clk),
        .reg1(reg1),
        .reg2(reg2),
        .reg3(reg3),
        .imm(imm),
        .opcode(opcode),
        .init_values(init_values),
        .result(result)
    );
endmodule