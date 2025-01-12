`include "Processor.v"
module Processor_tb;
    reg clk;
    reg reset;
    reg [15:0] instruction;
    wire [15:0] result;
    reg [15:0] init_values [0:7]; // Array to initialize registers

    Processor uut (
        .clk(clk),
        .reset(reset),
        .instruction(instruction),
        .init_values(init_values),
        .result(result)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        // Initialize registers
        init_values[0] = 16'd10;
        init_values[1] = 16'd20;
        init_values[2] = 16'd30;
        init_values[3] = 16'd0;
        init_values[4] = 16'd0;
        init_values[5] = 16'd0;
        init_values[6] = 16'd0;
        init_values[7] = 16'd0;

        reset = 1;
        #10;
        reset = 0;

        // Test ADD (RRR-type)
        instruction = 16'b000_000_001_0000_010; // rA = rB + rC (r0 = r1 + r2)
        #10;
        $display("ADD Result: %d", result);

        // Test ADDI (RRI-type)
        instruction = 16'b001_000_001_000_0001; // rA = rB + imm (r0 = r1 + 1)
        #10;
        $display("ADDI Result: %d", result);

        // Test SUBI (RRI-type)
        instruction = 16'b010_000_001_000_0001; // rA = rB - imm (r0 = r1 - 1)
        #10;
        $display("SUBI Result: %d", result);

        // Test SUB (RRR-type)
        instruction = 16'b011_000_001_0000_010; // rA = rB - rC (r0 = r1 - r2)
        #10;
        $display("SUB Result: %d", result);

        $stop;
    end
endmodule
