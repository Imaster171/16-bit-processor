`include "../alu.v"

module alu_tb;
    reg [15:0] a, b;
    reg [2:0] opcode;
    wire [15:0] result;
    wire zero;

    // Instantiate the ALU
    alu uut (
        .a(a),
        .b(b),
        .opcode(opcode),
        .result(result),
        .zero(zero)
    );

    initial begin
        // Test case 1: ADD
        a = 16'h0001; 
        b = 16'h0002; 
        opcode = 3'b000; // ADD opcode
        #10;
        $display("Test case 1: ADD, a=%h, b=%h, result=%h", a, b, result);
        if (result !== 16'h0003) $display("Test case 1 failed: expected 3, got %d", result);

        // Test case 2: SUB
        a = 16'h0005; 
        b = 16'h0003; 
        opcode = 3'b001; // SUB opcode
        #10;
        $display("Test case 2: SUB, a=%h, b=%h, result=%h", a, b, result);
        if (result !== 16'h0002) $display("Test case 2 failed: expected 2, got %d", result);

        // Test case 3: AND
        a = 16'h000F; 
        b = 16'h00F0; 
        opcode = 3'b010; // AND opcode
        #10;
        $display("Test case 3: AND, a=%h, b=%h, result=%h", a, b, result);
        if (result !== 16'h0000) $display("Test case 3 failed: expected 0, got %d", result);

        // Test case 4: OR
        a = 16'h000F; 
        b = 16'h00F0; 
        opcode = 3'b011; // OR opcode
        #10;
        $display("Test case 4: OR, a=%h, b=%h, result=%h", a, b, result);
        if (result !== 16'h00FF) $display("Test case 4 failed: expected 255, got %d", result);

        // Test case 5: XOR
        a = 16'h000F; 
        b = 16'h00F0; 
        opcode = 3'b100; // XOR opcode
        #10;
        $display("Test case 5: XOR, a=%h, b=%h, result=%h", a, b, result);
        if (result !== 16'h00FF) $display("Test case 5 failed: expected 255, got %d", result);

        // Test case 6: SLT
        a = 16'h0001; 
        b = 16'h0002; 
        opcode = 3'b101; // SLT opcode
        #10;
        $display("Test case 6: SLT, a=%h, b=%h, result=%h", a, b, result);
        if (result !== 16'h0001) $display("Test case 6 failed: expected 1, got %d", result);

        // End simulation
        $finish;
    end
endmodule