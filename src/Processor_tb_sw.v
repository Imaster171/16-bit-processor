`include "processor.v"

module processor_tb_sw;

    reg clk;
    reg reset;

    // Instantiate the processor
    processor uut (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation
    always #10 clk = ~clk; // 10 time units period

    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;

        // Apply reset
        #10 reset = 0;

        // Run until PC reaches 5
        wait (uut.pc == 5);
        #10 $finish;
    end

    // Monitor the processor state
    always @(posedge clk) begin
        $display("Time: %0t | PC: %0d | Instruction: %b | Opcode: %b ",
                 $time, uut.pc, uut.instruction, uut.opcode);
    end

    always @(negedge clk) begin
        $display("Registers: r0: %0d | r1: %0d | r2: %0d | r3: %0d | r4: %0d | r5: %0d | r6: %0d | r7: %0d",
                 $signed(uut.regfile.reg_file[0]), $signed(uut.regfile.reg_file[1]), $signed(uut.regfile.reg_file[2]), $signed(uut.regfile.reg_file[3]),
                 $signed(uut.regfile.reg_file[4]), $signed(uut.regfile.reg_file[5]), $signed(uut.regfile.reg_file[6]), $signed(uut.regfile.reg_file[7]));
    end

endmodule