module sys_top 
(
	input wire ref_clk, uart_clk, rst, 
	input wire rx_in, 
	output wire tx_out
);
//rst signals
wire ref_rst, uart_rst;
//clk signals
wire alu_clk, rx_clk, tx_clk, rx_clk_in0; //this one is an input to the mux;
//valid signals 
wire alu_valid, tx_d_valid, rx_d_valid, rx_d_valid_sync, reg_rd_valid;
//flags 
wire busy, full, empty;
//enbale signals
wire wr_en, rd_en, alu_en, clk_en, rd_inc, wr_inc;

wire [2:0] rx_clk_div_ratio;
wire [3:0] addr, alu_fun;
//p_data signals
wire [7:0] reg0, reg1, reg2, reg_wr_data, reg_rd_data, fifo_w_data, tx_p_data, rx_p_data, rx_p_data_sync;
//alu out
wire [15:0] alu_out;

UART_TOP UART (
	.rx_clk(rx_clk),
	.rst(uart_rst),
	.par_en(reg2[0]),
	.par_typ(reg2[1]),
	.prescale(reg2[6:2]),
	.rx_in(rx_in),

	.rx_p_data(rx_p_data),
	.rx_d_valid(rx_d_valid),

	.tx_clk(tx_clk),
	.tx_p_data(tx_p_data),
	.tx_d_valid(!empty),

	.busy(busy),
	.tx_out(tx_out)
);

data_sync u_data_sync (
	.clk(ref_clk), 
	.rst(ref_rst), 
	.async_data_en(rx_d_valid),
	.async_data(rx_p_data), 
	.sync_data(rx_p_data_sync),
	.sync_data_en(rx_d_valid_sync)
);

sys_ctrl u_sys_ctrl (
	.clk(ref_clk), 
	.rst(ref_rst),
	.alu_valid(alu_valid), 
	.rx_d_valid(rx_d_valid_sync), 
	.rd_d_valid(reg_rd_valid), 
	.full(full), 
	.alu_out(alu_out), 
	.rx_p_data(rx_p_data_sync), 
	.rd_data(reg_rd_data),
	.alu_en(alu_en), 
	.clk_en(clk_en), 
	.wr_en(wr_en), 
	.rd_en(rd_en), 
	.wr_inc(wr_inc),
	.alu_fun(alu_fun),
	.addr(addr),
	.wr_data(reg_wr_data), 
	.fifo_p_data(fifo_w_data)
);

reg_file RegFile (
	.clk(ref_clk),
	.rst(ref_rst),
	.wr_en(wr_en),
	.rd_en(rd_en),
	.wr_data(reg_wr_data),
	.addr(addr),
	.rd_data(reg_rd_data), 
	.reg0(reg0), 
	.reg1(reg1), 
	.reg2(reg2), 
	.rd_valid(reg_rd_valid)
);

ALU u_ALU (
	.clk(alu_clk),
	.rst(ref_rst), 
	.en(alu_en), 
	.A(reg0), 
	.B(reg1), 
	.ALU_FUN(alu_fun), 
	.ALU_OUT(alu_out), 
	.alu_valid(alu_valid)
);

async_fifo_top FIFO (
	.wclk(ref_clk), 
	.wrst(ref_rst), 
	.winc(wr_inc), 
	.rclk(tx_clk), 
	.rrst(uart_rst), 
	.rinc(rd_inc), 
	.wdata(fifo_w_data), 
	.rdata(tx_p_data), 
	.full(full), 
	.empty(empty)
);

clk_gating u_clk_gating (
	.clk(ref_clk), 
	.clk_en(clk_en), 
	.gated_clk(alu_clk)
);

rst_sync rst_sync_ref (
	.clk(ref_clk),
    .rst(rst),
	.sync_rst(ref_rst)
);

rst_sync rst_sync_uart (
	.clk(uart_clk),
    .rst(rst),
	.sync_rst(uart_rst)
);

pulse_gen u_pulse_gen (
	.clk(tx_clk), 
	.rst(uart_rst), 
	.in(!busy), 
	.pulse(rd_inc)
);

//this mux is to either div the uart clk or bypass it
mux_2_to_1 rx_clk_mux (
	.in1(uart_clk),
	.in0(rx_clk_in0),
	.sel(rx_clk_div_ratio=='d1),
	.out(rx_clk)
);

clk_div_diff_ratio rx_clk_div (
	.i_ref_clk(uart_clk), 
	.i_rst_n(uart_rst), 
	.i_div_ratio(rx_clk_div_ratio),
	.o_div_clk(rx_clk_in0)
);

//divides by 32
clk_div_fxd_ratio tx_clk_div (
	.i_ref_clk(uart_clk), 
	.i_rst_n(uart_rst), 
	.o_div_clk(tx_clk)
);

prescale_mux u_prescale_mux (
	.prescale(reg2[6:2]),
	.rx_clk_div_ratio(rx_clk_div_ratio)
);

endmodule





