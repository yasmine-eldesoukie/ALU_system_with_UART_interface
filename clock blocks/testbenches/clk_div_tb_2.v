module clk_div_tb_2 ();
//signal declartion
reg clk,rst, en_tb;
reg [3:0] div_ratio_tb;
wire [15:0] div_clk_dut; //16 bits, one for each clock variation

//instatiation
//for easier debugging, all clock varaitions are on top of one another, starting from (f/2) to (f/15)
generate 
  genvar j;
  for (j=0; j<16; j=j+1) begin
	  clk_div dut (
	  .i_ref_clk(clk),
	  .i_rst_n(rst),
	  .i_clk_en(en_tb),
	  .i_div_ratio(div_ratio_tb+j),
	  .o_div_clk(div_clk_dut[15-j])
	  );
	end
endgenerate


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
	div_ratio_tb='b0;
	repeat (30) @(negedge clk);

	// Test 2: clk_en dominance 
	rst=1'b1;
	en_tb=1'b0;
	div_ratio_tb='b0;
    repeat (30) @(negedge clk);
	rst=1'b0;
	repeat (3) @(negedge clk);
	
	// Test 3:  
	rst=1'b1;
	en_tb=1'b1;
	div_ratio_tb='b0;
    repeat (30) @(negedge clk);
	
	$stop;

end
endmodule