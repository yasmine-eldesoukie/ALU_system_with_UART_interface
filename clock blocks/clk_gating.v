module clk_gating (
	input wire clk,
	input wire clk_en, //latch input
	output reg gated_clk
);

//clk, clk_en, gated_clk
reg latch_out;

always @(clk or clk_en) begin
	if(!clk) begin
		latch_out<= clk_en;
	end
end

always @(*) begin
	gated_clk = clk & latch_out;
end

/*
//cell from library
TLATNCAX12M U0_TLATNCAX12M (
.E(CLK_EN|test_en), //test_mode not test_en , right?
.CK(CLK),
.ECK(GATED_CLK)
);

*/
endmodule