module data_memory (
    input clk,                      // Clock signal
    input [15:0] address,           // Address to access memory
    input [15:0] write_data,        // Data to write to memory
    input mem_write,                // Memory write enable signal
    output reg [15:0] read_data     // Data read from memory
);

    // Memory array (1024 words, 16 bits each)
    reg [15:0] memory [0:1023];

    // Synchronous write operation
    always @(posedge clk) begin
        if (mem_write) begin
            memory[address] <= write_data;
        end
    end

    // Asynchronous read operation
    always @(*) begin
        read_data = memory[address];
    end

endmodule
