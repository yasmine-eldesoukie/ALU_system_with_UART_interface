//this will generate all clock variations one after the other
module clk_div_tb ();
//signal declartion
reg clk,rst, en_tb;
reg [3:0] div_ratio_tb;
wire div_clk_dut;

//instatiation
clk_div dut (
	.i_ref_clk(clk),
	.i_rst_n(rst),
	.i_clk_en(en_tb),
	.i_div_ratio(div_ratio_tb),
	.o_div_clk(div_clk_dut)
	);

//clk generation
initial begin
	clk=1'b0;
	forever
        #1 clk=~clk;
end

//stimulus generation
integer i;
initial begin
	
	rst=1'b0;
	repeat (10) @(negedge clk);

	// Test 1: reset dominance 
	en_tb=1'b1;
	for (i=0; i<16 ; i=i+1) begin
		div_ratio_tb=i;
	    repeat (30) @(negedge clk);
	end

	// Test 2: clk_en dominance 
	rst=1'b1;
	en_tb=1'b0;
	for (i=0; i<16 ; i=i+1) begin
		rst=1'b1;
		div_ratio_tb=i;
	    repeat (30) @(negedge clk);
	    rst=1'b0;
	    repeat (3) @(negedge clk);
	end

	// Test 3: different values for div_ratio
	en_tb=1'b1;
	for (i=0; i<16 ; i=i+1) begin
		rst=1'b1;
		div_ratio_tb=i;
	    repeat (30) @(negedge clk);
	    rst=1'b0;
	    repeat (3) @(negedge clk);
	end

	$stop;

end
endmodule