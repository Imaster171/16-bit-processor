module program_counter (
    input clk,                      // Clock signal
    input reset,                    // Reset signal
    input branch_enable,            // Branch enable signal
    input [9:0] branch_address,     // Branch address
    output reg [9:0] pc             // Program counter
);

    // Program counter logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 10'b0; // Reset PC to 0
        end else if (branch_enable) begin
            pc <= pc + branch_address; // Branch to address
        end else begin
            pc <= pc + 1; // Increment PC
        end
    end

endmodule
