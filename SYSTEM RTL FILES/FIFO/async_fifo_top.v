module async_fifo_top 
#(parameter 
	WIDTH=8,
	ADDR=3,
	NUM_STAGES=2,
	BUS_WIDTH=4
)
(
	input wire wclk, wrst, winc, rclk, rrst, rinc,
	input wire [WIDTH-1:0] wdata,
	output wire [WIDTH-1:0] rdata,
	output wire full, empty
);

// w_clk, w_rst, w_inc, r_clk, r_rst, r_inc, wdata, rdata, full, empty

wire [ADDR:0] rptr, wq2_rptr, wptr, rq2_wptr;
wire [ADDR-1:0] waddr, raddr;

fifo_wr #(.ADDR_WIDTH(ADDR)) FIFO_wr (
	.clk(wclk),
	.rst(wrst),
	.inc(winc),
	.rptr(wq2_rptr),
	.wptr_gray(wptr),
	.waddr(waddr),
	.full(full)
);

fifo_rd #(.ADDR_WIDTH(ADDR)) FIFO_rd (
	.clk(rclk),
	.rst(rrst),
	.inc(rinc),
	.wptr(rq2_wptr),
	.rptr_gray(rptr),
	.raddr(raddr),
	.empty(empty)
);

bit_sync #(.BUS_WIDTH(BUS_WIDTH)) sync_r2w (
	.clk(wclk),
	.rst(wrst),
	.async(rptr),
	.sync(wq2_rptr)
);

bit_sync #(.BUS_WIDTH(BUS_WIDTH)) sync_w2r (
	.clk(rclk),
	.rst(rrst),
	.async(wptr),
	.sync(rq2_wptr)
);

fifo_mem #(.WIDTH(WIDTH), .ADDR(ADDR)) FIFO_memory (
	.wclk(wclk),
	.rst(wrst),
	.wclk_en((winc & !full)),
	.waddr(waddr),
	.raddr(raddr),
	.wdata(wdata),
	.rdata(rdata)
);

endmodule