`include "../register_file.v"
module register_file_tb;

    // Declare testbench signals
    reg clk;                      // Clock signal
    reg reset;                    // Reset signal
    reg [2:0] read_addr1;         // Read address 1
    reg [2:0] read_addr2;         // Read address 2
    reg [2:0] write_addr;         // Write address
    reg [15:0] write_data;        // Write data
    reg write_enable;             // Write enable signal
    wire [15:0] read_data1;       // Read data 1
    wire [15:0] read_data2;       // Read data 2

    // Instantiate the register file
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
    always begin
        #5 clk = ~clk; // Toggle clock every 5 time units
    end

    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        reset = 0;
        write_enable = 0;
        write_data = 16'b0;
        write_addr = 3'b0;
        read_addr1 = 3'b0;
        read_addr2 = 3'b0;

        // Test 1: Apply reset
        $display("Test 1: Apply reset");
        reset = 1;
        #10 reset = 0; // Deassert reset after 10 time units
        #10;

        // Test 2: Write to register 0, 1, and 2
        $display("Test 2: Write to registers");
        write_enable = 1;
        write_addr = 3'b000;
        write_data = 16'hA5A5; // Write A5A5 to register 0
        #10;
        
        write_addr = 3'b001;
        write_data = 16'h5A5A; // Write 5A5A to register 1
        #10;
        
        write_addr = 3'b010;
        write_data = 16'h1234; // Write 1234 to register 2
        #10;

        // Test 3: Read from registers
        $display("Test 3: Read from registers");
        read_addr1 = 3'b000;
        read_addr2 = 3'b001; // Read from registers 0 and 1
        #10;
        $display("Read data 1: %h, Read data 2: %h", read_data1, read_data2);

        // Test 4: Write to register 3 and read again
        $display("Test 4: Write to register 3 and read again");
        write_addr = 3'b011;
        write_data = 16'hFFFF; // Write FFFF to register 3
        #10;

        read_addr1 = 3'b011; // Read from register 3
        read_addr2 = 3'b000; // Read from register 0
        #10;
        $display("Read data 1: %h, Read data 2: %h", read_data1, read_data2);

        // Test 5: Check reset functionality
        $display("Test 5: Check reset functionality");
        reset = 1;
        #10 reset = 0; // Deassert reset
        #10;
        read_addr1 = 3'b000; // Read register 0 (should be 0 after reset)
        read_addr2 = 3'b001; // Read register 1 (should be 0 after reset)
        #10;
        $display("Read data 1: %h, Read data 2: %h", read_data1, read_data2);
        
        // Test 6: Write and verify specific values
        $display("Test 6: Write and verify specific values");
        write_addr = 3'b100;
        write_data = 16'hDEAD; // Write DEAD to register 4
        write_enable = 1;
        #10;
        read_addr1 = 3'b100; // Read register 4
        #10;
        $display("Read data from register 4: %h", read_data1);
        
        // Test 7: Disable write and verify no change
        $display("Test 7: Disable write and verify no change");
        write_enable = 0;
        write_addr = 3'b100;
        write_data = 16'hBEEF; // Trying to write BEEF but should not happen
        #10;
        read_addr1 = 3'b100; // Read register 4 again
        #10;
        $display("Read data from register 4: %h", read_data1); // Should still be DEAD

        // End of test
        $finish;
    end

endmodule
