// Instruction Memory
module instruction_memory (
    input [9:0] address,           // Address to fetch the instruction
    output reg [15:0] instruction // Output instruction
);
    // Memory array for instructions (1024 instructions max, 16-bit each)
    reg [15:0] memory [0:1023];

    // Initialize instruction memory (example instructions, adjust as needed)
    initial begin
        memory[0] = 16'b010_011_000_0000110; // ADDI r3, r0, 6
        memory[1] = 16'b010_001_010_0000100; // ADDI r1, r2, 4
        memory[2] = 16'b000_000_001_0000_011; // ADD  r0, r1, r3
        memory[3] = 16'b100_001_001_0000010; // BEQ r1, r1, 2 (example)
        memory[4] = 16'b011_100_001_0000010; // SUBI r4, r1, 2
        memory[5] = 16'b011_001_011_0000001; // SUBI r1, r3, 1
        memory[6] = 16'b001_101_011_0000_001; // SUB  r5, r3, r1
        // Additional instructions can be added here
    end

    // Fetch instruction based on address
    always @(*) begin
        instruction = memory[address];
    end
endmodule