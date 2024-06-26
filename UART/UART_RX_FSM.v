module UART_RX_FSM 
#(parameter 
	IDLE=3'b000,
	START=3'b001,
	DATA=3'b011,
	PARITY=3'b010,
	STOP=3'b110,
	OUT=3'b100
)
(
	input wire clk,rst,par_en,
	input wire data,
	input wire [4:0] prescale,edge_count,
	input wire [3:0] bit_count,
	input wire par_err, strt_glitch, stp_err,
	//output reg data_samp_en, edge_bit_counter_en, 
	output reg samp_edge_bit_counter_en, par_chk_en, strt_chk_en, stp_chk_en, deser_en, data_valid
);

reg [2:0] cs,ns;
reg sampled_ready;

always @(posedge clk or negedge rst) begin
	if (!rst) 
	  cs<=IDLE;
	else 
	  cs<=ns;
end

always @(*) begin
	case (cs) 
      IDLE: begin
      	if (!data)
      	  ns=START;
      	else 
      	  ns=IDLE;
      end

      START: begin
      	if (sampled_ready & strt_glitch)
      	  ns= IDLE;
      	else if (sampled_ready)
      	  ns= DATA;
      	else 
      	  ns= START;
      end

      DATA: begin
      	if (bit_count==9 & par_en) 
      	  ns=PARITY;
      	else if (bit_count==9) 
      	  ns=STOP;
      	else 
      	  ns=DATA;
      end

      PARITY: begin
      	 if (sampled_ready & par_err)
      	   ns=IDLE;
      	 else if (sampled_ready)
      	   ns=STOP;
      	 else
      	   ns=PARITY;      	 
      end

      STOP: begin
      	if (sampled_ready & stp_err)
      	  ns=IDLE;
      	else if (sampled_ready)
      	  ns=OUT;
      	else
      	  ns=STOP;
      end

      OUT: begin
      	  ns=IDLE;
      end

      default:
          ns=IDLE;

	endcase
end

always @(*) begin
    	//data_samp_en=(cs!=IDLE);
      //edge_bit_counter_en=(cs !=IDLE);
      samp_edge_bit_counter_en=(cs!=IDLE); //combine the two enable signals since they have the same logic and redo the wiring in the top module
   	  par_chk_en=(cs==PARITY & sampled_ready );
     	strt_chk_en=(cs==START & sampled_ready);
    	stp_chk_en=(cs==STOP & sampled_ready);
    	deser_en=(cs==DATA & sampled_ready ); //shaka feek
    	data_valid=(cs==OUT);
end

always @(*) begin
    sampled_ready=(edge_count==prescale);
end

endmodule

//does the state change at edge_count = prescale or 0??? zero
/* comment on sampling and edge_bit enable signals logic:
"(cs !=IDLE ) & !strt_glitch & !par_err & !stp_err " drives the same result as cs!=IDLE on it's own but bit_count jumps to 1 then back to 0 in case of a glitch/error
---- I'm not sure which is better in terms of area, power and timing analysis yet
*/