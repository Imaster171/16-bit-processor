module Processor (
    input wire clk,
    input wire [15:0] opcode,
    output reg [15:0] result
);
    reg signed [15:0] rA, rB, rC, imm;
    reg [15:0] instruction_memory [0:255]; // Instruction memory

    initial begin
        // Initialize instruction memory with some instructions
        instruction_memory[0] = 16'b000_000_001_010_0000; // ADD
        instruction_memory[1] = 16'b001_000_001_000_0001; // ADDI
        instruction_memory[2] = 16'b010_000_001_000_0001; // SUBI
        instruction_memory[3] = 16'b011_000_001_010_0000; // SUB
    end

    always @(posedge clk) begin
        case (opcode[15:13])
            3'b000: begin // ADD (RRR-type)
                rA = opcode[12:10];
                rB = opcode[9:7];
                rC = opcode[6:4];
                rA = rB + rC;
                result = rA;
            end
            3'b001: begin // ADDI (RRI-type)
                rA = opcode[12:10];
                rB = opcode[9:7];
                imm = {{9{opcode[6]}}, opcode[6:0]}; // Sign-extend 7-bit immediate
                rA = rB + imm;
                result = rA;
            end
            3'b010: begin // SUBI (RRI-type)
                rA = opcode[12:10];
                rB = opcode[9:7];
                imm = {{9{opcode[6]}}, opcode[6:0]}; // Sign-extend 7-bit immediate
                rA = rB - imm;
                result = rA;
            end
            3'b011: begin // SUB (RRR-type)
                rA = opcode[12:10];
                rB = opcode[9:7];
                rC = opcode[6:4];
                rA = rB - rC;
                result = rA;
            end
            default: result = 16'b0;
        endcase
    end
endmodule
