`timescale 1ns / 1ps
`include "../data_memory.v"

module data_memory_tb;

    // Testbench signals
    reg clk;
    reg [15:0] address;
    reg [15:0] write_data;
    reg mem_write;
    wire [15:0] read_data;

    // Instantiate the data_memory module
    data_memory uut (
        .clk(clk),
        .address(address),
        .write_data(write_data),
        .mem_write(mem_write),
        .read_data(read_data)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    // Testbench logic
    initial begin
        // Initialize inputs
        address = 0;
        write_data = 0;
        mem_write = 0;

        // Wait for global reset
        #10;

        // Test 1: Write and read from address 0
        address = 16'd0;
        write_data = 16'hA5A5;
        mem_write = 1;
        #10;

        mem_write = 0; // Disable write for the read operaion
        #10;
        $display("Address: %d, Expected Data: %h, Read Data: %h", address, 16'hA5A5, read_data);

        // Test 2: Write and read from address 100
        address = 16'd1023;
        write_data = 16'h1234;
        mem_write = 1;
        #10;

        mem_write = 0; // Disable write for the read operaion
        #10;
        $display("Address: %d, Expected Data: %h, Read Data: %h", address, 16'h1234, read_data);

        // Test 3: Read from an uninitialized address
        address = 16'd200;
        #10;
        $display("Address: %d, Expected Data: %h, Read Data: %h", address, 16'hxxxx, read_data);

        #20;
        $finish;
    end

endmodule
