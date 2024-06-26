module fifo_wr #(parameter ADDR_WIDTH=3)
(
	input wire clk,rst,inc,
	input wire [ADDR_WIDTH:0] rptr, //gray encoded
	output reg [ADDR_WIDTH-1:0] waddr,
	output reg [ADDR_WIDTH:0] wptr_gray,
	output reg full 
);

reg [ADDR_WIDTH:0] wptr;

always @(posedge clk or negedge rst) begin
	if (!rst) begin
        wptr <= 'b0;
	end
	else if (!full & inc) begin
		wptr<=wptr+1;
	end
end

//waddr
always @(*) begin
	waddr= wptr[ADDR_WIDTH-1:0];
end


//gray encoding 
always @(posedge clk or negedge rst) begin
	if (!rst) begin
		wptr_gray<= 'b0;
	end
	else begin
		case (wptr)
             4'b0000: wptr_gray<= 4'b0000;
             4'b0001: wptr_gray<= 4'b0001;
             4'b0010: wptr_gray<= 4'b0011;
             4'b0011: wptr_gray<= 4'b0010;

             4'b0100: wptr_gray<= 4'b0110;
             4'b0101: wptr_gray<= 4'b0111;
             4'b0110: wptr_gray<= 4'b0101;
             4'b0111: wptr_gray<= 4'b0100;

             4'b1000: wptr_gray<= 4'b1100;
             4'b1001: wptr_gray<= 4'b1101;
             4'b1010: wptr_gray<= 4'b1111;
             4'b1011: wptr_gray<= 4'b1110;

             4'b1100: wptr_gray<= 4'b1010;
             4'b1101: wptr_gray<= 4'b1011;
             4'b1110: wptr_gray<= 4'b1001;
             4'b1111: wptr_gray<= 4'b1000;
		endcase
	end
end

//full flag
always @(*) begin
	full= ((rptr[ADDR_WIDTH] != wptr_gray[ADDR_WIDTH]) & (rptr[ADDR_WIDTH-1:0] == wptr_gray[ADDR_WIDTH-1:0]));
end
endmodule
