module alu (
    input [15:0] a,          // First operand
    input [15:0] b,          // Second operand
    input [2:0] opcode,      // Operation code
    output reg [15:0] result, // Result of the operation
    output reg zero          // Zero flag
);

    always @(*) begin
        case (opcode)
            3'b000: result = a + b;      // ADD
            3'b001: result = a - b;      // SUB
            3'b010: result = a + b;      // ADDI
            3'b011: result = a - b;      // SUBI
            default: result = 16'b0;     // Default case
        endcase
        
        zero = (result == 16'b0); // Set zero flag if result is zero
    end

endmodule