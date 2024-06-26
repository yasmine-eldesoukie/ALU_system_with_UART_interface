`timescale 1us/100ns
module reg_file_tb #(parameter WIDTH=16 , LINES=8);
//signal declaration
reg [WIDTH-1:0] wr_data_tb;
reg [$clog2(LINES)-1:0] addr_tb;
reg wr_en_tb,rd_en_tb,clk,rst_tb;
wire [WIDTH-1:0] rd_data_dut;
//instantiation
reg_file #(WIDTH,LINES) dut (
	.wr_data(wr_data_tb),
	.addr(addr_tb),
	.wr_en(wr_en_tb),
	.rd_en(rd_en_tb),
	.clk(clk),
	.rst(rst_tb),
	.rd_data(rd_data_dut)
	);
//clock generation
always #1 clk=~clk;
//stimulus generation
integer i;

initial begin
	$dumpfile("register file");
	$dumpvars;
	//initial values
	clk       =0;
	wr_en_tb  =0;
	rd_en_tb  =0;
	wr_data_tb=0;
	addr_tb   =0;
	rst_tb    =0;
	repeat (30) @(negedge clk);

	// ---------------------------------------- reset  on , enable signals on ----------------------------------------
	                     // // // // // // //  Test Case 1 for Write // // // // // // //
                                // in each cell , store a value equal to its number
	@(negedge clk);
	wr_en_tb=1;
	for (i=0 ; i<LINES ; i=i+1) begin
		@(negedge clk);
		addr_tb=i;
		wr_data_tb=i;
	end 
	                     // // // // // // //  Test Case 1 for Read // // // // // // //
	                                        // now read these values
	@(negedge clk);
	wr_en_tb=0;
	wr_data_tb='d0;
	rd_en_tb=1;
	for (i=0 ; i<LINES ; i=i+1) begin
		addr_tb=i;
		@(negedge clk);
	end                        
	   // *************** as inputs change , output should still be zero because of reset *************** 


	// ---------------------------------------- reset  off , enable signals on ----------------------------------------
	                     // // // // // // //  Test Case 2 for Write // // // // // // //
                                // in each cell , store a value equal to its number
	@(negedge clk);
	rst_tb=1;
	rd_en_tb=0;
	wr_en_tb=1;
	for (i=0 ; i<LINES ; i=i+1) begin
		@(negedge clk);
		addr_tb=i;
		wr_data_tb=i;
	end 
	                     // // // // // // //  Test Case 2 for Read // // // // // // //
	                                        // now read these values
	@(negedge clk);
	wr_en_tb=0;
    wr_data_tb='d0;
	rd_en_tb=1;
	for (i=0 ; i<LINES ; i=i+1) begin
		addr_tb=i;
		@(negedge clk);
	end                      
	   // *************** as reset is off, rd_data_dut waveform should = i for each iteration *************** 
    @(negedge clk);
    $stop;	                   
end
endmodule