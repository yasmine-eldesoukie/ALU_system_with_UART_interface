module mux_4_to_1 (
	input wire [1:0] sel,
	input wire s2,s3,
	output reg mux_out
	);

always @(*) begin
	if (sel==2'b00)
	  mux_out=1'b0;
	else if (sel==2'b01)
	  mux_out=1'b1;
	else if (sel==2'b10)
	  mux_out=s2;
	else 
	  mux_out=s3;
end

endmodule