`include "OpcodeDecoder.v"
module Processor (
    input wire clk,
    input wire reset,
    input wire [15:0] instruction,
    input wire [15:0] init_values [0:7], // Array to initialize registers
    output wire [15:0] result
);
    OpcodeDecoder decoder (
        .clk(clk),
        .reset(reset),
        .instruction(instruction),
        .init_values(init_values),
        .result(result)
    );
endmodule
