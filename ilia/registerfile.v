module RegisterFile (
    input wire clk,                      // Clock signal
    input wire reset,                    // Reset signal
    input wire [2:0] read_addr1,         // Read address for register 1 (3-bit)
    input wire [2:0] read_addr2,         // Read address for register 2 (3-bit)
    input wire [2:0] write_addr,         // Write address (3-bit)
    input wire [15:0] write_data,        // Data to write (16-bit)
    input wire write_enable,             // Write enable signal (1 bit)
    input wire [15:0] init_values [0:7], // Array to initialize registers
    output reg [15:0] read_data1,        // Data from register 1 (16-bit)
    output reg [15:0] read_data2         // Data from register 2 (16-bit)
);

    // Declare the register file with 8 registers, each 16 bits wide
    reg [15:0] registers [7:0];          // 8 registers, each 16 bits wide

    // Asynchronous read operations
    always @(*) begin
        read_data1 = registers[read_addr1]; // Read data from register 1
        read_data2 = registers[read_addr2]; // Read data from register 2
    end

    // Synchronous write operation
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers with init_values on reset signal
            registers[0] <= init_values[0];
            registers[1] <= init_values[1];
            registers[2] <= init_values[2];
            registers[3] <= init_values[3];
            registers[4] <= init_values[4];
            registers[5] <= init_values[5];
            registers[6] <= init_values[6];
            registers[7] <= init_values[7];
        end
        else if (write_enable) begin
            // Write data to the register if write_enable is high
            registers[write_addr] <= write_data;
        end
    end

endmodule
