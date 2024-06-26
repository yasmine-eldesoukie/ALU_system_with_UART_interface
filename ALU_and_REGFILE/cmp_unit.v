module cmp_unit #(parameter WIDTH=16)
(
	input wire [WIDTH-1:0] a,b,
	input wire [1:0] func,
	input wire clk, rst, enable ,
	output wire cmp_flag,
	output reg [WIDTH-1:0] cmp_out
);

//flag logic
assign cmp_flag=( rst && enable);

//arithmetic logic
always @(negedge rst or posedge clk) begin
	if (!rst) begin
		cmp_out<='d0;
	end
	else if (enable) begin
		cmp_out<='d0;
		case (func) 
		  2'b00: begin
	          cmp_out<='d0;
		  end
		  2'b01: begin
		      if (a==b)
		         cmp_out<='d1;
		      else 
		         cmp_out<='d0;
		  end
		  2'b10: begin
	           if (a>b)
		         cmp_out<='d2;
		      else 
		         cmp_out<='d0;
		  end
		  2'b11: begin
	           if (a<b)
		         cmp_out<='d3;
		      else 
		         cmp_out<='d0;
		  end
		  default: begin
	          cmp_out<='d0;
		  end
		endcase
	end
	else begin
		cmp_out<='d0;
	end
end //always
endmodule