module instruction_decoder (
    input [15:0] instruction, // 16-bit instruction input
    output reg [2:0] alu_op,  // ALU operation control signal
    output reg reg_write,     // Register write enable
    output reg mem_read,      // Memory read enable
    output reg mem_write,     // Memory write enable
    output reg branch,        // Branch control signal
    output reg jump           // Jump control signal
);

    // Extracting the 3-bit opcode from instruction (bits 15–13)
    wire [2:0] opcode;
    assign opcode = instruction[15:13];

    always @(*) begin
        // Default control signals
        alu_op = 3'b000; // Default ALU operation (ADD)
        reg_write = 0;   // Default: No register write
        mem_read = 0;    // Default: No memory read
        mem_write = 0;   // Default: No memory write
        branch = 0;      // Default: No branching
        jump = 0;        // Default: No jumping

        // Opcode-based control signal generation
        case (opcode)
            3'b000: begin // ADD
                alu_op = 3'b000; // ALU performs addition
                reg_write = 1;   // Write result to register
            end
            3'b001: begin // ADDI
                alu_op = 3'b000; // ALU performs addition
                reg_write = 1;   // Write result to register
            end
            3'b010: begin // SUB
                alu_op = 3'b001; // ALU performs subtraction
                reg_write = 1;   // Write result to register
            end
            3'b011: begin // SUBI
                alu_op = 3'b001; // ALU performs subtraction
                reg_write = 1;   // Write result to register
            end
            3'b100: begin // LUI (Load Upper Immediate)
                alu_op = 3'b011; // ALU performs OR (for LUI-style behavior)
                reg_write = 1;   // Write result to register
            end
            3'b101: begin // BEQ (Branch if Equal)
                branch = 1;      // Enable branch control signal
                alu_op = 3'b001; // Subtraction to compare `a - b`
            end
            3'b110: begin // SW (Store Word)
                mem_write = 1;   // Write to memory
            end
            3'b111: begin // LW (Load Word)
                mem_read = 1;    // Read from memory
                reg_write = 1;   // Write result to register
            end
            default: begin
                // Keep all control signals as default (no operation)
                alu_op = 3'b000;
                reg_write = 0;
                mem_read = 0;
                mem_write = 0;
                branch = 0;
                jump = 0;
            end
        endcase
    end

endmodule
