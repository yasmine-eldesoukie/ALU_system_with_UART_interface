module clk_div_diff_ratio #(parameter DIV_RATIO_WIDTH=3)(
	input wire i_ref_clk, i_rst_n, //i_clk_en, //remove it ; it'll be on as long as div_ratio is neither 0 nor 1
	input wire [DIV_RATIO_WIDTH-1:0] i_div_ratio,
	output reg o_div_clk
	);

// i_ref_clk, i_rst_n, i_div_ratio,o_div_clk

reg [DIV_RATIO_WIDTH-2:0] counter;
reg count_up_done, count_dn_done;
reg en;

reg [DIV_RATIO_WIDTH-2:0] up_counts;
reg [DIV_RATIO_WIDTH-1:0] dn_counts;

always @(*) begin
	up_counts = i_div_ratio[DIV_RATIO_WIDTH-1:1];
    dn_counts = (i_div_ratio[0] == 1'b0 )? up_counts : up_counts+1;
    en =(i_div_ratio != 'b0 & i_div_ratio != 'b1);
end
 
always @(posedge i_ref_clk or negedge i_rst_n) begin
	if (! i_rst_n) begin
		counter<='b0;
        count_up_done<=1'b0;
        count_dn_done<=1'b0;
        o_div_clk<=1'b0;
	end
	else if (en & !count_up_done) begin //we will check it before the block
		o_div_clk<=1'b1;
		counter<=counter+1;
		if(counter== up_counts-1) begin
			counter<='b0;
			count_up_done<=1'b1;
			count_dn_done<=1'b0;
		end
	end
	else if (en & !count_dn_done) begin
        o_div_clk<=1'b0;
        counter<=counter+1;
		if(counter== dn_counts-1) begin
			counter<='b0;
			count_up_done<=1'b0;
			count_dn_done<=1'b1;
		end
	end
	else begin
	    o_div_clk<=1'b0;
		counter<='b0;
        count_up_done<=1'b0;
        count_dn_done<=1'b0;
	end
end

endmodule