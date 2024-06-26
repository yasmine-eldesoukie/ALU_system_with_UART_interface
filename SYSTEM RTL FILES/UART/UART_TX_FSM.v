module UART_TX_FSM 
#(parameter 
	IDLE=3'b000,
	START=3'b001,
	DATA=3'b011,
	PARITY=3'b010,
	STOP=3'b110
)
(
input wire clk, rst,
input wire data_valid, ser_done, par_en,
output reg ser_en, busy,
output reg [1:0] mux_sel
);

reg [2:0] cs,ns;

always @(posedge clk or negedge rst) begin
	if (!rst) 
	  cs<=IDLE;
	else 
	  cs<=ns;
end

always @(*) begin
	case(cs)
	IDLE: begin
		if (data_valid) 
		   ns=START;
		else 
		   ns=IDLE;
	end 

	START: begin
		   ns=DATA;
	end

	DATA: begin
		if (ser_done & par_en)
           ns=PARITY;
        else if (ser_done & !par_en)
           ns=STOP;
        else 
           ns=DATA;
	end

	STOP: begin
		if (data_valid) 
		   ns=START;
		else 
		   ns=IDLE;
	end

	default: begin
		   ns=IDLE;
	end

	endcase
end

always @(*) begin
	ser_en=1'b0;
	busy=1'b0;
	mux_sel=2'b01;

	case (cs)
	START: begin
		ser_en=1'b1;
		busy=1'b1;
		mux_sel=2'b00;
	end 

	DATA: begin
		ser_en=1'b1;
		busy=1'b1;
		mux_sel=2'b10;
	end 

	PARITY: begin
		ser_en=1'b0;
		busy=1'b1;
		mux_sel=2'b11;
	end 

	STOP: begin
		ser_en=1'b0;
		busy=1'b1;
		mux_sel=2'b01;
	end 

	default: begin
		ser_en=1'b0;
		busy=1'b0;
		mux_sel=2'b01;
	end
	endcase
end

endmodule