`include "../instruction_decoder.v"

module instruction_decoder_tb;
    // Testbench signals
    reg [15:0] instruction;
    wire [2:0] alu_op;
    wire reg_write;
    wire mem_read;
    wire mem_write;
    wire branch;
    wire jump;

    // Instantiate the instruction decoder
    instruction_decoder uut (
        .instruction(instruction),
        .alu_op(alu_op),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .branch(branch),
        .jump(jump)
    );

    // Task to display outputs and check correctness
    task check_result;
        input [2:0] expected_alu_op;
        input expected_reg_write;
        input expected_mem_read;
        input expected_mem_write;
        input expected_branch;
        input expected_jump;
        begin
            $display("Instruction: %b | ALU_OP: %b | RegWrite: %b | MemRead: %b | MemWrite: %b | Branch: %b | Jump: %b",
                     instruction, alu_op, reg_write, mem_read, mem_write, branch, jump);
            if (alu_op === expected_alu_op &&
                reg_write === expected_reg_write &&
                mem_read === expected_mem_read &&
                mem_write === expected_mem_write &&
                branch === expected_branch &&
                jump === expected_jump) begin
                $display("PASS\n");
            end else begin
                $display("FAIL\n");
            end
        end
    endtask

    initial begin
        // Test ADD (opcode 000)
        instruction = 16'b000_001_010_0000_001; // Example RRR-type: reg A=001, reg C=0001
        #10;
        check_result(3'b000, 1, 0, 0, 0, 0); // Expected: ALU_OP=000, RegWrite=1, others=0

        // Test ADDI (opcode 001)
        instruction = 16'b001_010_011_0000111; // Example RRI-type: reg A=010, reg B=011, imm=7
        #10;
        check_result(3'b000, 1, 0, 0, 0, 0); // Expected: ALU_OP=000, RegWrite=1, others=0

        // Test SUB (opcode 010)
        instruction = 16'b010_011_100_0000_000; // Example RRR-type: reg A=011, reg C=0000
        #10;
        check_result(3'b001, 1, 0, 0, 0, 0); // Expected: ALU_OP=001, RegWrite=1, others=0

        // Test SUBI (opcode 011)
        instruction = 16'b011_001_1111111111; // Example RI-type: reg A=001, imm=1023
        #10;
        check_result(3'b001, 1, 0, 0, 0, 0); // Expected: ALU_OP=001, RegWrite=1, others=0

        // Test LUI (opcode 100)
        instruction = 16'b100_010_011_1111111; // Example RRI-type: reg A=010, reg B=011, imm=-1
        #10;
        check_result(3'b011, 1, 0, 0, 0, 0); // Expected: ALU_OP=011, RegWrite=1, others=0

        // Test BEQ (opcode 101)
        instruction = 16'b101_100_101_0000001; // Example RRI-type: reg A=100, reg B=101, imm=1
        #10;
        check_result(3'b001, 0, 0, 0, 1, 0); // Expected: ALU_OP=001, Branch=1, others=0

        // Test SW (opcode 110)
        instruction = 16'b110_101_110_0000100; // Example RRI-type: reg A=101, reg B=110, imm=4
        #10;
        check_result(3'b000, 0, 0, 1, 0, 0); // Expected: ALU_OP=000, MemWrite=1, others=0

        // Test LW (opcode 111)
        instruction = 16'b111_111_000_0000000; // Example: reg A=111, reg B=000
        #10;
        check_result(3'b000, 1, 1, 0, 0, 0); // Expected: ALU_OP=000, RegWrite=1, MemRead=1, others=0

        // End simulation
        $finish;
    end
endmodule
