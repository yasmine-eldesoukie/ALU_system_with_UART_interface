module rst_sync #(parameter NUM_STAGES=2, BUS_WIDTH=1)
(   
	input wire clk, rst,
	output wire sync_rst
);

bit_sync #(.NUM_STAGES(NUM_STAGES), .BUS_WIDTH(BUS_WIDTH)) u_rst_sync (
	.clk(clk),
	.rst(rst),
	.async(1'b1),
	.sync(sync_rst)
);

endmodule