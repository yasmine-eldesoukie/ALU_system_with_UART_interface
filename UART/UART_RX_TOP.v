module UART_RX_TOP (
	input wire clk, rst, rx_in,par_en, par_typ, 
	input wire [4:0] prescale,
	output wire data_valid,
	output wire [7:0] p_data
);

wire sampled_bit;
wire [4:0] edge_count;
wire [3:0] bit_count;
//wire data_samp_en, par_chk_en;
wire samp_edge_bit_counter_en, strt_chk_en, stp_chk_en, deser_en;
wire par_err, strt_glitch, stp_err;

UART_RX_FSM FSM (
	.clk(clk),
	.rst(rst),
	.par_en(par_en),
	.data(rx_in),
	.prescale(prescale),
	.edge_count(edge_count),
	.bit_count(bit_count),
	.par_err(par_err), 
	.strt_glitch(strt_glitch), 
	.stp_err(stp_err),
	//.data_samp_en(data_samp_en), 
	//.edge_bit_counter_en(edge_bit_counter_en),
	.samp_edge_bit_counter_en(samp_edge_bit_counter_en), 
	.par_chk_en(par_chk_en), 
	.strt_chk_en(strt_chk_en), 
	.stp_chk_en(stp_chk_en), 
	.deser_en(deser_en), 
	.data_valid(data_valid)
	);

edge_bit_counter u_edge_bit_counter (
	.clk(clk), 
	.rst(rst), 
	.enable(samp_edge_bit_counter_en),
	.prescale(prescale),
	.edge_count(edge_count),
	.bit_count(bit_count)
	);

data_sampling u_data_sampling (
	.clk(clk), 
	.rst(rst), 
	.enable(samp_edge_bit_counter_en),
	.data(rx_in),
	.prescale(prescale),
	.edge_count(edge_count),
	.sampled_bit(sampled_bit)
	);

start_check u_start_check (
	.strt_chk_en(strt_chk_en),
	.sampled_bit(sampled_bit),
	.strt_glitch(strt_glitch)
	);

deserializer u_deser (
	.clk(clk), 
	.rst(rst), 
	.enable(deser_en),
	.sampled_bit(sampled_bit),
	.data(p_data)
	);

parity_check u_parity_check (
	.par_chk_en(par_chk_en),
	.par_typ(par_typ), 
	.sampled_bit(sampled_bit),
	.data(p_data),
	.par_err(par_err)
	);

stop_check u_stop_check (
	.stp_chk_en(stp_chk_en),
	.sampled_bit(sampled_bit),
	.stp_err(stp_err)
	);

endmodule