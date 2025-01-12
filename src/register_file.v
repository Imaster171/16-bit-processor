module register_file(
    input clk,                      // Clock signal
    input reset,                    // Reset signal
    input [2:0] read_addr1,         // Read address for register 1 (3-bit)
    input [2:0] read_addr2,         // Read address for register 2 (3-bit)
    input [2:0] write_addr,         // Write address (3-bit)
    input [15:0] write_data,        // Data to write (16-bit)
    input write_enable,             // Write enable signal (1 bit)
    output reg [15:0] read_data1,   // Data from register 1 (16-bit)
    output reg [15:0] read_data2    // Data from register 2 (16-bit)
);

    // Declare the register file with 8 registers, each 16 bits wide
    reg [15:0] reg_file [7:0];      // 8 registers, each 16 bits wide

    // Initialize registers with default values
    initial begin
        reg_file[0] = 16'b0;
        reg_file[1] = 16'b0;
        reg_file[2] = 16'b0;
        reg_file[3] = 16'b0;
        reg_file[4] = 16'b0;
        reg_file[5] = 16'b0;
        reg_file[6] = 16'b0;
        reg_file[7] = 16'b0;
    end

    // Asynchronous read operations
    always @(*) begin
        read_data1 = reg_file[read_addr1]; // Read data from register 1
        read_data2 = reg_file[read_addr2]; // Read data from register 2
    end

    // Synchronous write operation
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all registers to 0 on reset signal
            reg_file[0] <= 16'b0;
            reg_file[1] <= 16'b0;
            reg_file[2] <= 16'b0;
            reg_file[3] <= 16'b0;
            reg_file[4] <= 16'b0;
            reg_file[5] <= 16'b0;
            reg_file[6] <= 16'b0;
            reg_file[7] <= 16'b0;
        end
        else if (write_enable) begin
            // Write data to the register if write_enable is high
            reg_file[write_addr] <= write_data;
        end
    end

endmodule
