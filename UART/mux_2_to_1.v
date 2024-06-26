module mux_2_to_1 (
	input wire in1, in0,sel,
	output reg out
	);

always @(*) begin
	out=(sel)? in1: in0;
end
endmodule