module deserializer (
	input wire clk,rst,enable,
	input wire sampled_bit,
	output reg [7:0] data
);

always @(posedge clk or negedge rst) begin
	if (!rst) begin
		data<=8'b0;
	end
	else if (enable) begin
		data<={sampled_bit,data[7:1]};
	end
end

endmodule