module edge_bit_counter (
	input wire clk, rst, enable,
	input wire [4:0] prescale,
	output reg [3:0] bit_count,
	output reg [4:0] edge_count
);

reg [4:0] edge_counter;
reg bit_change;

always @(posedge clk or negedge rst) begin
	if (!rst) begin
		bit_count<=4'b0;
		edge_count<=4'd0; 
		edge_counter<='b1;
		bit_change<=1'b0;
	end

	else if (enable ) begin
	    edge_count<=edge_counter;
	    edge_counter<=edge_counter+1;
		if (edge_counter==prescale) begin
		    edge_counter<=4'b0;
		    bit_change<=1'b1;
	    end
	    else if (bit_change) begin
	    	bit_count<=bit_count+1;
	    	bit_change<=1'b0;
	    end
	end 

	else begin
		bit_count<=4'b0;
		edge_count<=4'b0;
		edge_counter<='b1; 
		bit_change<=1'b0;
	end
end

 /*
always @(posedge clk or negedge rst) begin
	if (!rst) begin
		edge_count<=4'd0;
		edge_counter<='b1;
		bit_change<=1'b0;
	end

	else if (enable) begin
		edge_count<=edge_counter;
		if (edge_counter==prescale) begin
			edge_counter<='b0;
			bit_change<=1'b1;
		end
		else begin
		    edge_counter<=edge_counter+1;
			bit_change<=1'b0;
		end
	end 
	else begin
		edge_count<=4'b0;
		edge_counter<='b1; 
		bit_change<=4'b0;
	end
end

always @(posedge clk or negedge rst) begin
	if (!rst) begin
		bit_count<=4'b0;
	end
	else if (enable & bit_change) begin
		bit_count<=bit_count+1;
	end
	else if (!enable) begin
		bit_count<='b0;
	end
end
 */

endmodule

