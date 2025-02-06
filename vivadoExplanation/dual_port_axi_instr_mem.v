`include "processor.v"
`timescale 1 ns / 1 ps

module dual_port_axi_instr_mem #
(
    parameter integer DATA_WIDTH = 32,  // Data width
    parameter integer ADDR_WIDTH = 8 // Address width (2^ADDR_WIDTH memory locations) //// so we have 256 memory addresses of 32 bits each we can use for our processor.
)
(

    // AXI4-Full Slave Interface
    input wire  S_AXI_ACLK,
    input wire  S_AXI_ARESETN,
    input wire  S_AXI_AWVALID,
    input wire  [ADDR_WIDTH-1:0] S_AXI_AWADDR,
    output wire S_AXI_AWREADY,
    input wire  [DATA_WIDTH-1:0] S_AXI_WDATA,
    input wire  [DATA_WIDTH/8-1:0] S_AXI_WSTRB,
    input wire  S_AXI_WVALID,
    output wire S_AXI_WREADY,
    output wire [1:0] S_AXI_BRESP,
    output wire S_AXI_BVALID,
    input wire  S_AXI_BREADY,
    input wire  S_AXI_ARVALID,
    input wire  [ADDR_WIDTH-1:0] S_AXI_ARADDR,
    output wire S_AXI_ARREADY,
    output wire [DATA_WIDTH-1:0] S_AXI_RDATA,
    output wire [1:0] S_AXI_RRESP,
    output wire S_AXI_RVALID,
    input wire  S_AXI_RREADY

    // Define some Direct Access Interfaces here

);

    // Memory Array
    reg [DATA_WIDTH-1:0] mem [0:2**ADDR_WIDTH-1];
   

    // AXI Read/Write Control Signals
    reg axi_awready, axi_wready, axi_arready, axi_rvalid, axi_bvalid;
    reg [DATA_WIDTH-1:0] axi_rdata;
    reg [1:0] axi_bresp, axi_rresp;

    // Assign outputs
    assign S_AXI_AWREADY = axi_awready;
    assign S_AXI_WREADY  = axi_wready;
    assign S_AXI_BRESP   = axi_bresp;
    assign S_AXI_BVALID  = axi_bvalid;
    assign S_AXI_ARREADY = axi_arready;
    assign S_AXI_RDATA   = axi_rdata;
    assign S_AXI_RRESP   = axi_rresp;
    assign S_AXI_RVALID  = axi_rvalid;

    // AXI Write Address Handling
    always @(posedge S_AXI_ACLK)
    begin
        if (!S_AXI_ARESETN)
            axi_awready <= 1'b0;
        else if (~axi_awready && S_AXI_AWVALID)
            axi_awready <= 1'b1;
        else
            axi_awready <= 1'b0;
    end

    // AXI Write Data Handling
    always @(posedge S_AXI_ACLK)
    begin
        if (!S_AXI_ARESETN)
            axi_wready <= 1'b0;
        else if (~axi_wready && S_AXI_WVALID)
            axi_wready <= 1'b1;
        else
            axi_wready <= 1'b0;
    end
    
    wire [9:0] pc;
    wire [15:0] instruction;
    wire [15:0] reg_b, reg_c, reg_a;
    reg [15:0] python_instruction;
    ////initiaizing the processor.v:
    processor riskvProcessor (
        .clk(S_AXI_ACLK),
        .reset(S_AXI_ARESETN),
        .pc(pc),
        .instruction2(instruction),
        .reg_b_data(reg_b),
        .reg_c_data(reg_c),
        .reg_a_data(reg_a),
        .python_instruction(python_instruction)
    );

	// Memory Write from AXI
	always @(posedge S_AXI_ACLK)
	begin
		if (S_AXI_WVALID && axi_wready)
		begin
				if (S_AXI_WSTRB[0]) mem[S_AXI_AWADDR][7:0]   <= S_AXI_WDATA[7:0];
				if (S_AXI_WSTRB[1]) mem[S_AXI_AWADDR][15:8]  <= S_AXI_WDATA[15:8];
				if (S_AXI_WSTRB[2]) mem[S_AXI_AWADDR][23:16] <= S_AXI_WDATA[23:16];
				if (S_AXI_WSTRB[3]) mem[S_AXI_AWADDR][31:24] <= S_AXI_WDATA[31:24];/*
               	////writing to the first 32 bits changing 1sand 0s:
                mem[0][31:0] <= 32'b11001100110011001100110011001100;
                ////writing all 1s to the second one:
                mem[1][31:0] <= 32'b11111111111111111111111111111111;*/
                //THE ONLY WORKING MEMORY ADDRESSES:
                //mem[0][31:0] <= 32'b11001100110011001100110011001100;//this corresponds to 0x0 32 bits.
                //mem[2][31:0] <= 64'b11110000111100001111000011110000;//this corresponds to 0x4 32 bits.
		//from our findings, we can only read and write from these 2*32 bit memory addresses using python, while in the testbench created with iverilog outputs works properly.

		//getting instructions to our processor via python:
                python_instruction <= mem[0][15:0];
		
                // writing registries back out to memory to read via python to make sure it all functions:
		mem[0][31:16] <= reg_c;
		
                mem[2][31:16] <= reg_a;
                mem[2][15:0] <= reg_b;
		end
	end

    // AXI Write Response
    always @(posedge S_AXI_ACLK)
    begin
        if (!S_AXI_ARESETN)
        begin
            axi_bvalid <= 1'b0;
            axi_bresp  <= 2'b00;
        end
        else if (axi_awready && S_AXI_AWVALID && ~axi_bvalid)
        begin
            axi_bvalid <= 1'b1;
            axi_bresp  <= 2'b00; // OKAY response
        end
        else if (S_AXI_BREADY && axi_bvalid)
        begin
            axi_bvalid <= 1'b0;
        end
    end

    // AXI Read Address Handling
    always @(posedge S_AXI_ACLK)
    begin
        if (!S_AXI_ARESETN)
            axi_arready <= 1'b0;
        else if (~axi_arready && S_AXI_ARVALID)
            axi_arready <= 1'b1;
        else
            axi_arready <= 1'b0;
    end

    // AXI Read Data Handling
    always @(posedge S_AXI_ACLK)
    begin
        if (!S_AXI_ARESETN)
        begin
            axi_rvalid <= 1'b0;
            axi_rresp  <= 2'b00;
        end
        else if (axi_arready && S_AXI_ARVALID && ~axi_rvalid)
        begin
            axi_rvalid <= 1'b1;
            axi_rresp  <= 2'b00; // OKAY response
            axi_rdata  <= mem[S_AXI_ARADDR]; // Read from memory
        end
        else if (S_AXI_RREADY && axi_rvalid)
        begin
            axi_rvalid <= 1'b0;
        end
    end

    // Direct Memory Logics ?? Interacting with the "mem" 
    



endmodule
