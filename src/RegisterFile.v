module RegisterFile (
    input wire clk,
    input wire [2:0] reg1,
    input wire [2:0] reg2,
    input wire [2:0] reg3,
    input wire [15:0] imm,
    input wire [2:0] opcode,
    input wire [15:0] init_values [0:7], // Array to initialize registers
    output reg [15:0] result
);
    reg signed [15:0] registers [0:7]; // 8 registers, each 16 bits wide

    integer i;
    initial begin
        for (i = 0; i < 8; i = i + 1) begin
            registers[i] = init_values[i];
        end
    end

    always @(posedge clk) begin
        case (opcode)
            3'b000: begin // ADD
                registers[reg1] = registers[reg2] + registers[reg3];
                result = registers[reg1];
            end
            3'b001: begin // ADDI
                registers[reg1] = registers[reg2] + imm;
                result = registers[reg1];
            end
            3'b010: begin // SUBI
                registers[reg1] = registers[reg2] - imm;
                result = registers[reg1];
            end
            3'b011: begin // SUB
                registers[reg1] = registers[reg2] - registers[reg3];
                result = registers[reg1];
            end
            default: result = 16'b0;
        endcase
    end
endmodule
