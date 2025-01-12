module OpcodeDecoder (
    input wire clk,
    input wire reset,
    input wire [15:0] instruction,
    input wire [15:0] init_values [0:7], // Array to initialize registers
    output wire [15:0] result
);
    wire [2:0] reg1 = instruction[12:10];
    wire [2:0] reg2 = instruction[9:7];
    wire [2:0] reg3 = instruction[6:4];
    wire [15:0] imm = {{9{instruction[6]}}, instruction[6:0]}; // Sign-extend 7-bit immediate
    wire [2:0] opcode = instruction[15:13];

    wire [15:0] read_data1, read_data2;
    reg [15:0] write_data;
    reg write_enable;

    RegisterFile rf (
        .clk(clk),
        .reset(reset),
        .read_addr1(reg2),
        .read_addr2(reg3),
        .write_addr(reg1),
        .write_data(write_data),
        .write_enable(write_enable),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    always @(*) begin
        write_enable = 1'b0;
        case (opcode)
            3'b000: begin // ADD
                write_data = read_data1 + read_data2;
                write_enable = 1'b1;
            end
            3'b001: begin // ADDI
                write_data = read_data1 + imm;
                write_enable = 1'b1;
            end
            3'b010: begin // SUBI
                write_data = read_data1 - imm;
                write_enable = 1'b1;
            end
            3'b011: begin // SUB
                write_data = read_data1 - read_data2;
                write_enable = 1'b1;
            end
            default: write_data = 16'b0;
        endcase
    end

    assign result = write_data;
endmodule