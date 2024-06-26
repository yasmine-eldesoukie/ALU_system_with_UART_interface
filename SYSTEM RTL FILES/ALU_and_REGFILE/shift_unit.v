module shift_unit #(parameter WIDTH=16)
(
	input wire [WIDTH-1:0] a,b,
	input wire [1:0] func,
	input wire clk, rst, enable ,
	output wire shift_flag,
	output reg [WIDTH-1:0] shift_out
);

//flag logic
assign shift_flag=( rst && enable);

//arithmetic logic
always @(negedge rst or posedge clk) begin
	if (!rst) begin
		shift_out<='d0;
	end
	else if (enable) begin
		shift_out<='d0;
		case (func) 
		  2'b00: begin
	          shift_out<=a>>1;
		  end
		  2'b01: begin
	          shift_out<=a<<1;
		  end
		  2'b10: begin
	          shift_out<=b>>1;
		  end
		  2'b11: begin
	          shift_out<=b<<1;
		  end
		  default: begin
		      shift_out<='d0;
		  end
		endcase
	end
	else begin
		shift_out<='d0;
	end
end //always
endmodule