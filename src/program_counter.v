module program_counter (
    input clk,                      // Clock signal
    input reset,                    // Reset signal
    input [9:0] next_pc,            // Next PC value for JALR
    output reg [9:0] pc             // Program counter
);

    // Program counter logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 10'b0;            // Reset PC to 0
        end else begin
            pc <= next_pc;          // Set PC to next_pc
        end
    end

endmodule
