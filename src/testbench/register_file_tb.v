`include "../register_file.v"

module tb_register_file;

    // Inputs
    reg clk;
    reg reset;
    reg [2:0] read_addr1;
    reg [2:0] read_addr2;
    reg [2:0] write_addr;
    reg [15:0] write_data;
    reg write_enable;

    // Outputs
    wire [15:0] read_data1;
    wire [15:0] read_data2;

    // Instantiate the register_file module
    register_file uut (
        .clk(clk),
        .reset(reset),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .write_addr(write_addr),
        .write_data(write_data),
        .write_enable(write_enable),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk; // 10ns clock period

    // Test sequence
    initial begin
        // Initialize inputs
        reset = 1;
        read_addr1 = 0;
        read_addr2 = 0;
        write_addr = 0;
        write_data = 0;
        write_enable = 0;

        // Apply reset
        #10 reset = 0;

        // Write to register 3
        write_addr = 3;
        write_data = 16'hA5A5;
        write_enable = 1;
        #10 write_enable = 0;

        // Write to register 5
        write_addr = 5;
        write_data = 16'h5A5A;
        write_enable = 1;
        #10 write_enable = 0;

        // Read from registers 3 and 5
        read_addr1 = 3;
        read_addr2 = 5;
        #10;

        // Check and display outputs
        $display("Register: %d, Expected Data: %h, Read Data: %h", 3, 16'hA5A5, read_data1);
        $display("Register: %d, Expected Data: %h, Read Data: %h", 5, 16'h5A5A, read_data2);

        // Reset and verify all registers are cleared
        reset = 1;
        #10 reset = 0;
        read_addr1 = 3;
        read_addr2 = 5;
        #10;
        $display("After reset - Register: %d, Expected Data: %h, Read Data: %h", 3, 16'h0000, read_data1);
        $display("After reset - Register: %d, Expected Data: %h, Read Data: %h", 5, 16'h0000, read_data2);

        // Test write and overwrite
        write_addr = 3;
        write_data = 16'h1234;
        write_enable = 1;
        #10 write_enable = 0;

        write_addr = 3;
        write_data = 16'h5678;
        write_enable = 1;
        #10 write_enable = 0;

        read_addr1 = 3;
        #10;
        $display("Register: %d, Expected Data: %h, Read Data: %h", 3, 16'h5678, read_data1);

        $finish;
    end

endmodule
