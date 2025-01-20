`timescale 1ns / 1ps
`include "../alu.v"

module alu_tb;

    reg signed [15:0] a;
    reg signed [15:0] b;
    reg [2:0] opcode;
    wire signed [15:0] result;
    wire zero;

    // Instantiate the ALU module
    alu uut (
        .a(a),
        .b(b),
        .opcode(opcode),
        .result(result),
        .zero(zero)
    );

    initial begin
        // Test 1: ADD operation
        a = 16'sd10;
        b = 16'sd20;
        opcode = 3'b000;
        #10;
        $display("Test 1 - ADD: a = %d, b = %d, result = %d, zero = %b", a, b, result, zero);

        // Test 2: ADDI operation
        a = -16'sd15;
        b = 16'sd5;
        opcode = 3'b001;
        #10;
        $display("Test 2 - ADDI with negative: a = %d, b = %d, result = %d, zero = %b", a, b, result, zero);

        // Test 3: SUBI operation
        a = 16'sd30;
        b = 16'sd50;
        opcode = 3'b010;
        #10;
        $display("Test 3 - SUBI: a = %d, b = %d, result = %d, zero = %b", a, b, result, zero);

        // Test 4: SUBI operation
        a = 16'sd30;
        b = -16'sd50;
        opcode = 3'b010;
        #10;
        $display("Test 4 - SUBI with negative: a = %d, b = %d, result = %d, zero = %b", a, b, result, zero);

        // Test 5: Default case
        a = 16'sd10;
        b = -16'sd10;
        opcode = 3'b111;
        #10;
        $display("Test 5 - Default: a = %d, b = %d, result = %d, zero = %b", a, b, result, zero);

        // Test 6: Zero result case
        a = -16'sd25;
        b = -16'sd25;
        opcode = 3'b010;
        #10;
        $display("Test 6 - Zero Result SUBI: a = %d, b = %d, result = %d, zero = %b", a, b, result, zero);

        #20;
        $finish;
    end

endmodule
