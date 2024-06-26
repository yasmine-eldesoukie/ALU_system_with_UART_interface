module logic_unit #(parameter WIDTH=16)
(
	input wire [WIDTH-1:0] a,b,
	input wire [1:0] func,
	input wire clk, rst, enable ,
	output wire logic_flag,
	output reg [WIDTH-1:0] logic_out
);

//flag logic
assign logic_flag=( rst && enable);

//arithmetic logic
always @(negedge rst or posedge clk) begin
	if (!rst) begin
		logic_out<='d0;
	end
	else if (enable) begin
	    logic_out<='d0;
		case (func) 
		  2'b00: begin
	          logic_out<=a&b;
		  end
		  2'b01: begin
	          logic_out<=a|b;
		  end
		  2'b10: begin
	          logic_out<=~(a&b);
		  end
		  2'b11: begin
	          logic_out<=~(a|b);
		  end
		  default: begin
	          logic_out<='d0;
		  end
		endcase
	end
	else begin
	    logic_out<='d0;
	end
end //always
endmodule