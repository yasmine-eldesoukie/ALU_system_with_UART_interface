module pulse_gen (
	input wire clk, rst, 
	input wire in,
	output wire pulse
);

//clk, rst, in, pulse
reg d;

always @(posedge clk or negedge rst) begin
	if (!rst) begin
		d<=1'b1;
	end
	else begin
		d<=in;
	end
end

/*
always @(*) begin
	pulse= in & !d;
end
*/
assign 	pulse= in & !d;


endmodule