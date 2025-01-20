`timescale 1ns / 1ps
`include "../program_counter.v"

module program_counter_tb;

    // Inputs
    reg clk;
    reg reset;
    reg [9:0] next_pc;

    // Outputs
    wire [9:0] pc;

    // Instantiate the Unit Under Test (UUT)
    program_counter uut (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk; 

    // Stimulus generation
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        next_pc = 10'b0;

        // Display initial values
        $display("Time = %0t, clk = %b, reset = %b, next_pc = %b, pc = %b", $time, clk, reset, next_pc, pc); 

        #10;

        // Deassert reset
        reset = 0;
        $display("Time = %0t, clk = %b, reset = %b, next_pc = %b, pc = %b", $time, clk, reset, next_pc, pc); 

        #10;

        // Test case 1: Load a new PC value
        next_pc = 10'b1010;
        $display("Time = %0t, clk = %b, reset = %b, next_pc = %b, pc = %b", $time, clk, reset, next_pc, pc); 

        #10;

        // Test case 2: Load another PC value
        next_pc = 10'b1111;
        $display("Time = %0t, clk = %b, reset = %b, next_pc = %b, pc = %b", $time, clk, reset, next_pc, pc); 

        #10;

        // Test case 3: Reset the PC
        reset = 1;
        $display("Time = %0t, clk = %b, reset = %b, next_pc = %b, pc = %b", $time, clk, reset, next_pc, pc); 

        #10;
        reset = 0;
        next_pc = 10'b1;
        $display("Time = %0t, clk = %b, reset = %b, next_pc = %b, pc = %b", $time, clk, reset, next_pc, pc); 

        #10;
        reset = 0;
        $display("Time = %0t, clk = %b, reset = %b, next_pc = %b, pc = %b", $time, clk, reset, next_pc, pc); 

        $finish;
    end

endmodule