`timescale 1ns/1ps 
module sys_top_tb_simple #(parameter REF_PERIOD=10 , UART_PERIOD=272 );
//signal declaration
reg ref_clk, uart_clk, rst;
reg rx_in_tb;
wire tx_out_dut;

//internal signals
reg [7:0]  op, addr_tb, data_tb, op_A, op_B, alu_fun_tb;
reg [10:0] frame_op, frame_addr, frame_data, frame_op_A, frame_op_B, frame_alu_fun, current_frame;
reg [10:0] total_reg_wr_frame [3:0] ;

//reg [2:0] x;


//instantiation
 sys_top dut (
 	.ref_clk(ref_clk),
 	.uart_clk(uart_clk),
 	.rst(rst),
 	.rx_in(rx_in_tb),
 	.tx_out(tx_out_dut)
 );

//clks generation
  //ref clk
 initial begin
 	ref_clk = 1'b0;
 	forever #(REF_PERIOD) ref_clk=~ref_clk;
 end
 //uart clk
 initial begin
 	uart_clk = 1'b0;
 	forever #(UART_PERIOD) uart_clk=~uart_clk;
 end

//stimulus generation
integer k,u,v;
initial begin
	rst=1'b0;
	repeat (20) @(negedge uart_clk);

	//////////////// TEST CASE 1: test reset dominance, rst_sync will sync rst after 2 clks ////////////////
	rx_in_tb=1'b0;
	repeat (10) @(negedge uart_clk);
	rx_in_tb=1'b1;
	rst=1'b1;

    
	//////////////// TEST CASE 2: test regfile write operation and data_sync ////////////////
	// ------------ check regfile in dut to see if at addr 8 the data is "dd" ------------
	repeat (10) @(negedge uart_clk);
	op=8'hAA;
	frame_op= {1'b1, ^op, op, 1'b0};
	total_reg_wr_frame[0]=frame_op;
	addr_tb= 4'b1000;
	frame_addr= {1'b1, ^addr_tb, addr_tb, 1'b0};
	total_reg_wr_frame[1]=frame_addr;
    data_tb= 8'hdd;
	frame_data= {1'b1, ^data_tb, data_tb, 1'b0};
	total_reg_wr_frame[2]=frame_data;
	for (k=0; k<3; k=k+1) begin
	    current_frame= total_reg_wr_frame[k];
	        for(u=0; u<11; u=u+1) begin
		        for (v=0; v<32; v=v+1) begin
			        rx_in_tb=current_frame[u];
			        @(negedge uart_clk);
		        end
			    @(negedge uart_clk);
	        end
		    @(negedge uart_clk);
	end

	//////////////// TEST CASE 3: test regfile read operation, FIFO and tx_clk_div ////////////////
	// ------------ check if tx_out_dut = 1_0_1101_1101_0 ------------
	rx_in_tb=1'b1;
	repeat (10) @(negedge uart_clk);
	op=8'hBB;
	frame_op= {1'b1, ^op, op, 1'b0};
	total_reg_wr_frame[0]=frame_op;
	addr_tb= 4'b1000; //same address used to write data "dd" in
	frame_addr= {1'b1, ^addr_tb, addr_tb, 1'b0};
	total_reg_wr_frame[1]=frame_addr;
	for (k=0; k<2; k=k+1) begin
	    current_frame= total_reg_wr_frame[k];
	        for(u=0; u<11; u=u+1) begin
		        for (v=0; v<32; v=v+1) begin
			        rx_in_tb=current_frame[u];
			        @(negedge uart_clk);
		        end
			    @(negedge uart_clk);
	        end
		    @(negedge uart_clk);
	end


	repeat (32*20) @(negedge uart_clk);
    
	//////////////// TEST CASE 4: test ALU with 2 operands "sub" and clk_gating //////////////// 
	// ------------ check if tx_out_dut = A-B = 1_0_0000_0110_0 ------------
	rx_in_tb=1'b1;
	repeat (10) @(negedge uart_clk);
	op=8'hCC;
	frame_op= {1'b1, ^op, op, 1'b0};
	total_reg_wr_frame[0]=frame_op;

	op_A= 8'd8; //check if this value is loaded in reg0
	frame_op_A= {1'b1, ^op_A, op_A, 1'b0};
	total_reg_wr_frame[1]=frame_op_A;

	op_B= 8'd2; //check if this value is loaded in reg1
	frame_op_B= {1'b1, ^op_B, op_B, 1'b0};
	total_reg_wr_frame[2]=frame_op_B;

	alu_fun_tb= 8'd1; 
	frame_alu_fun= {1'b1, ^alu_fun_tb, alu_fun_tb, 1'b0};
	total_reg_wr_frame[3]=frame_alu_fun;

	for (k=0; k<4; k=k+1) begin
	    current_frame= total_reg_wr_frame[k];
	        for(u=0; u<11; u=u+1) begin
		        for (v=0; v<32; v=v+1) begin
			        rx_in_tb=current_frame[u];
			        @(negedge uart_clk);
		        end
			    @(negedge uart_clk);
	        end
		    @(negedge uart_clk);
	end


	repeat (32*50) @(negedge uart_clk);

	//////////////// TEST CASE 5: test ALU operation w/o operands "shift A" //////////////// 
	// ------------ check if tx_out_dut = A-B = 1_0_0000_0110_0 ------------
	rx_in_tb=1'b1;
	repeat (10) @(negedge uart_clk);
	op=8'hDD;
	frame_op= {1'b1, ^op, op, 1'b0};
	total_reg_wr_frame[0]=frame_op;

	alu_fun_tb= 8'd13; 
	frame_alu_fun= {1'b1, ^alu_fun_tb, alu_fun_tb, 1'b0};
	total_reg_wr_frame[1]=frame_alu_fun;

	for (k=0; k<2; k=k+1) begin
	    current_frame= total_reg_wr_frame[k];
	        for(u=0; u<11; u=u+1) begin
		        for (v=0; v<32; v=v+1) begin
			        rx_in_tb=current_frame[u];
			        @(negedge uart_clk);
		        end
			    @(negedge uart_clk);
	        end
		    @(negedge uart_clk);
	end

	repeat (32*20) @(negedge uart_clk);
	$stop;

end

endmodule
	


