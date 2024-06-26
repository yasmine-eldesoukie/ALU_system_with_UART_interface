module UART_TOP #(parameter DATA_WIDTH=8)(
	input rst,
	input wire tx_clk, 
	input wire par_en, par_typ,
	input wire tx_d_valid,
	input wire [DATA_WIDTH-1:0] tx_p_data,

	output wire busy, tx_out,

	input wire rx_clk,
	input wire [4:0] prescale,
	input wire rx_in,

	output wire [DATA_WIDTH-1:0] rx_p_data,
	output wire rx_d_valid
);

UART_RX_TOP RX (
	.clk(rx_clk),
	.rst(rst),
	.par_en(par_en),
	.par_typ(par_typ),
	.prescale(prescale),
	.rx_in(rx_in),

	.p_data(rx_p_data),
	.data_valid(rx_d_valid)
);

UART_TX_TOP TX (
	.clk(tx_clk),
	.rst(rst),
	.par_en(par_en),
	.par_typ(par_typ),
	.data_valid(tx_d_valid),
	.p_data(tx_p_data),

	.busy(busy),
	.tx_out(tx_out)
);

endmodule