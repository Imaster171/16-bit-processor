// Instruction Memory
module instruction_memory (
    input [9:0] address,           // Address to fetch the instruction
    output reg [15:0] instruction // Output instruction
);
    // Memory array for instructions (1024 instructions max, 16-bit each)
    reg [15:0] memory [0:1023];

    // Initialize instruction memory (example instructions, adjust as needed)
    initial begin
        memory[0] = 16'b001_011_000_0000011; // ADDI r3, r0, 3
        memory[1] = 16'b100_000_011_0000000; // JALR r0, r3
        memory[2] = 16'b001_001_000_0000100; // ADDI r1, r0, 4
        memory[3] = 16'b000_000_001_0000_011; // ADD  r0, r1, r3
        memory[4] = 16'b011_000_011_0000010; // BEQ r, r3, 2
        memory[5] = 16'b010_100_001_0000010; // SUBI r4, r1, 2
        memory[6] = 16'b010_001_011_0000001; // SUBI r1, r3, 1
        memory[7] = 16'b001_110_101_1111110; // ADDI r6, r5, -2 (signed)
        memory[8] = 16'b010_111_110_1111111; // SUBI r7, r6, -1 (signed)
        // Additional instructions can be added here
    end

    // Fetch instruction based on address
    always @(*) begin
        instruction = memory[address];
    end
endmodule