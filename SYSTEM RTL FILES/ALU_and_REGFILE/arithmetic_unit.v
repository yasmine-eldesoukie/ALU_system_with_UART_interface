module arithmetic_unit #(parameter WIDTH=16)
(
	input wire [WIDTH-1:0] a,b,
	input wire [1:0] func,
	input wire clk, rst, enable ,
	output wire arith_flag,
	output reg [WIDTH-1:0] arith_out,
	output reg carry_out
);

//flag logic
assign arith_flag=( rst && enable);

//arithmetic logic
always @(negedge rst or posedge clk) begin
	if (!rst) begin
		arith_out<='d0;
		carry_out<=1'b0;
	end
	else if (enable) begin
	    arith_out<='d0;
	    carry_out<='d0;
		case (func) 
		  2'b00: begin
			  {carry_out , arith_out }<=a+b;
		  end
		  2'b01: begin
			  arith_out<=a-b;
		  end
		  2'b10: begin
			  arith_out<=a*b;
		  end
		  2'b11: begin
			  arith_out<=a/b;
		  end
		  default: begin
		  	  arith_out<='d0;
	          carry_out<=1'b0;
		  end
		endcase
	end
	else begin
		arith_out<='d0;
	    carry_out<=1'b0;
	end
end //always
endmodule