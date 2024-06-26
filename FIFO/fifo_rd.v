module fifo_rd #(parameter ADDR_WIDTH=3)
(
	input wire clk,rst,inc,
	input wire [ADDR_WIDTH:0] wptr, //gray encoded
	output reg [ADDR_WIDTH-1:0] raddr,
	output reg [ADDR_WIDTH:0] rptr_gray,
	output reg empty 
);

reg [ADDR_WIDTH:0] rptr;

always @(posedge clk or negedge rst) begin
	if (!rst) begin
        rptr <= 'b0;
	end
	else if (!empty & inc) begin
		rptr<=rptr+1;
	end
end

//waddr
always @(*) begin
	raddr= rptr[ADDR_WIDTH-1:0];
end


//gray encoding 
always @(posedge clk or negedge rst) begin
	if (!rst) begin
		rptr_gray<= 'b0;
	end
	else begin
		case (rptr)
             4'b0000: rptr_gray<= 4'b0000;
             4'b0001: rptr_gray<= 4'b0001;
             4'b0010: rptr_gray<= 4'b0011;
             4'b0011: rptr_gray<= 4'b0010;

             4'b0100: rptr_gray<= 4'b0110;
             4'b0101: rptr_gray<= 4'b0111;
             4'b0110: rptr_gray<= 4'b0101;
             4'b0111: rptr_gray<= 4'b0100;

             4'b1000: rptr_gray<= 4'b1100;
             4'b1001: rptr_gray<= 4'b1101;
             4'b1010: rptr_gray<= 4'b1111;
             4'b1011: rptr_gray<= 4'b1110;

             4'b1100: rptr_gray<= 4'b1010;
             4'b1101: rptr_gray<= 4'b1011;
             4'b1110: rptr_gray<= 4'b1001;
             4'b1111: rptr_gray<= 4'b1000;
		endcase
	end
end

//empty flag
always @(*) begin
	empty= (wptr == rptr_gray);
end
endmodule
