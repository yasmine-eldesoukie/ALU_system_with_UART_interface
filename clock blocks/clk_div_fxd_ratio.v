module clk_div_fxd_ratio #(parameter DIV_RATIO=32, COUNTER_WIDTH=$clog2(DIV_RATIO))(
	input wire i_ref_clk, i_rst_n, //i_clk_en, remove it, for this system it's always on
	output reg o_div_clk
	);

// i_ref_clk, i_rst_n,o_div_clk
//2 DIV-2, 3 DIV-1
reg [COUNTER_WIDTH-2:0] counter; //since we will count to 31

always @(posedge i_ref_clk or negedge i_rst_n) begin
	if (! i_rst_n) begin
		counter<='b0;
        o_div_clk<=1'b0;
	end
	else if (counter== 'b0) begin
	    o_div_clk<=~o_div_clk;
	    counter<=counter+1;
	end
	//you don't need this cond. as when counter is max then inc. by 1 it loops back to 0
	/*else if (counter== DIV_RATIO-1)begin
		counter<='b0;
	end*/  
	else begin
		counter<=counter+1;
	end
end

endmodule