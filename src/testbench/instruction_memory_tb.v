`include "../instruction_memory.v"

module tb_instruction_memory;

    // Inputs
    reg [9:0] address;

    // Outputs
    wire [15:0] instruction;

    // Instantiate the instruction_memory module
    instruction_memory uut (
        .address(address),
        .instruction(instruction)
    );
    
    // Test sequence
    initial begin
        // Initialize address
        address = 0;
        #10
        // Test each memory location

        $display("Address: %d, Expected Instruction: %b, Read Instruction: %b", 
                 address, 16'b001_011_000_0000011, instruction);

        address = 1;
        #10
        $display("Address: %d, Expected Instruction: %b, Read Instruction: %b", 
                 address, 16'b100_000_011_0000000, instruction);

        address = 2;
        #10
        $display("Address: %d, Expected Instruction: %b, Read Instruction: %b", 
                 address, 16'b001_001_000_0000100, instruction);

        address = 3;
        #10
        $display("Address: %d, Expected Instruction: %b, Read Instruction: %b", 
                 address, 16'b000_000_001_0000_011, instruction);

        #20;
        $finish;
    end

endmodule