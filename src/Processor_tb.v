module Processor_tb;
    reg clk;
    reg [15:0] opcode;
    wire [15:0] result;

    Processor uut (
        .clk(clk),
        .opcode(opcode),
        .result(result)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        // Test ADD (RRR-type)
        opcode = 16'b000_000_001_010_0000; // rA = rB + rC
        #10;
        $display("ADD Result: %d", result);

        // Test ADDI (RRI-type)
        opcode = 16'b001_000_001_000_0001; // rA = rB + imm
        #10;
        $display("ADDI Result: %d", result);

        // Test SUBI (RRI-type)
        opcode = 16'b010_000_001_000_0001; // rA = rB - imm
        #10;
        $display("SUBI Result: %d", result);

        // Test SUB (RRR-type)
        opcode = 16'b011_000_001_010_0000; // rA = rB - rC
        #10;
        $display("SUB Result: %d", result);

        $stop;
    end
endmodule
