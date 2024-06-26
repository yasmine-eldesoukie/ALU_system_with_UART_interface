module fifo_mem #(parameter WIDTH=80, ADDR=3 , DEPTH=8)
(
	input wire wclk, wclk_en, rst,
	input wire [ADDR-1:0] waddr, raddr,
	input wire [WIDTH-1:0] wdata,
	output reg [WIDTH-1:0] rdata
);

reg [WIDTH-1:0] mem [DEPTH-1:0];

integer i;
always @(posedge wclk or negedge rst) begin
	if (!rst) begin
		rdata<= 'b0;
		for (i=0; i<DEPTH; i=i+1) begin
			mem[i]<= 'b0;
		end
	end

	else if (wclk_en) begin
		mem[waddr]<=wdata;
		// rdata<=mem[raddr]; //reading is async
	end
end

always @(*) begin
	rdata=mem[raddr];
end

endmodule