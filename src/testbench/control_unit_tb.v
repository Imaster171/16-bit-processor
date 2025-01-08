`include "../control_unit.v"

module control_unit_tb;

    // Testbench signals
    reg clk;
    reg reset;

    // Instantiate the control_unit
    control_unit uut (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Initialize the instruction ROM and test scenarios
    initial begin
        // Reset the system
        reset = 1;
        #10; // Wait for reset
        reset = 0;

        // Test instruction sequence
        // Load instructions into the instruction ROM
        uut.instruction_rom[0] = 16'b001_001_000_0000001; // ADDI x1, x0, 1
        uut.instruction_rom[1] = 16'b001_010_000_0000001; // ADDI x2, x0, 1
        uut.instruction_rom[2] = 16'b000_011_001_010_000; // ADD x3, x1, x2
        uut.instruction_rom[3] = 16'b000_100_010_011_000; // ADD x4, x2, x3
        uut.instruction_rom[4] = 16'b000_101_011_100_000; // ADD x5, x3, x4
        uut.instruction_rom[5] = 16'b000_110_100_101_000; // ADD x6, x4, x5
        uut.instruction_rom[6] = 16'b000_111_101_110_000; // ADD x7, x5, x6
        uut.instruction_rom[7] = 16'b000_000_110_111_000; // ADD x0, x6, x7 (dummy instruction to end)

        // Run the program
        #100; // Wait for 100ns to execute instructions

        // End simulation
        $finish;
    end

    // Monitor outputs for debugging
    always @(posedge clk) begin
        $display("Time: %0t | PC: %0d | Instruction: %b | ALU_OP: %b | ALU Result: %h | RegWrite: %b | MemRead: %b | MemWrite: %b | Branch: %b | Jump: %b",
                 $time, uut.pc, uut.instruction, uut.alu_op, uut.alu_result, uut.reg_write, uut.mem_read, uut.mem_write, uut.branch, uut.jump);
        case (uut.instruction[15:13])
            3'b000: $display("Executing: ADD");
            3'b001: $display("Executing: ADDI");
            3'b010: $display("Executing: SUB");
            3'b011: $display("Executing: SUBI");
            3'b100: $display("Executing: LUI");
            3'b101: $display("Executing: BEQ");
            3'b110: $display("Executing: SW");
            3'b111: $display("Executing: LW");
            default: $display("Executing: UNKNOWN");
        endcase
        $display("Register File State: x0=%h, x1=%h, x2=%h, x3=%h, x4=%h, x5=%h, x6=%h, x7=%h",
                 uut.rf.reg_file[0], uut.rf.reg_file[1], uut.rf.reg_file[2], uut.rf.reg_file[3],
                 uut.rf.reg_file[4], uut.rf.reg_file[5], uut.rf.reg_file[6], uut.rf.reg_file[7]);
    end

    // Check Fibonacci results
    initial begin
        #110; // Wait for instructions to complete
        check_result(1, 16'b0000000000000001, "Fibonacci x1");
        check_result(2, 16'b0000000000000001, "Fibonacci x2");
        check_result(3, 16'b0000000000000010, "Fibonacci x3");
        check_result(4, 16'b0000000000000011, "Fibonacci x4");
        check_result(5, 16'b0000000000000101, "Fibonacci x5");
        check_result(6, 16'b0000000000001000, "Fibonacci x6");
        check_result(7, 16'b0000000000001101, "Fibonacci x7");
    end

    task check_result(input [2:0] reg_num, input [15:0] expected_value, input [31:0] instruction_name);
        if (uut.rf.reg_file[reg_num] == expected_value) 
            $display("%s: PASS", instruction_name);
        else 
            $display("%s: FAIL", instruction_name);
    endtask

endmodule
