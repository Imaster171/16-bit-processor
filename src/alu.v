module alu (
    input signed [15:0] a,              // First operand (signed)
    input signed [15:0] b,              // Second operand (signed)
    input [2:0] opcode,                 // Operation code
    output reg signed [15:0] result,    // Result of the operation (signed)
    output reg zero                     // Zero flag
);

    always @(*) begin
        case (opcode)
            3'b000: result = a + b;     // ADD
            3'b001: result = a + b;     // ADDI
            3'b010: result = a - b;     // SUBI
            default: result = 16'b0;
        endcase
        
        zero = (result == 16'b0);       // Set zero flag if result is zero
    end

endmodule