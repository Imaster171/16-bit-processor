`include "processor.v"

module processor_tb;

    reg clk;
    reg reset;

    // Instantiate the processor
    processor uut (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation
    always #5 clk = ~clk; // 10 time units period

    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;

        // Apply reset
        #10 reset = 0;

        // Run until PC reaches 5
        wait (uut.pc == 4);
        #10 $finish;
    end

    // Monitor the processor state
    always @(posedge clk) begin
        $display("Time: %0t | PC: %0d | Instruction: %b | Opcode: %b | ReadAddr1: %d | ReadAddr2: %d | WriteAddr: %d | ReadData1: %d | ReadData2: %d | ALUResult: %d | WriteEnable: %b",
                 $time, uut.pc, uut.instruction, uut.opcode, uut.read_addr1, uut.read_addr2, uut.write_addr, uut.read_data1, uut.read_data2, uut.alu_result, uut.write_enable);
        $display("Registers: r0: %0d | r1: %0d | r2: %0d | r3: %0d | r4: %0d | r5: %0d | r6: %0d | r7: %0d",
                 uut.regfile.reg_file[0], uut.regfile.reg_file[1], uut.regfile.reg_file[2], uut.regfile.reg_file[3],
                 uut.regfile.reg_file[4], uut.regfile.reg_file[5], uut.regfile.reg_file[6], uut.regfile.reg_file[7]);
    end

endmodule