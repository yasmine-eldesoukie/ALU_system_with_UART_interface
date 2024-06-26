module stop_check (
	input wire stp_chk_en,
	input wire sampled_bit,
	output reg stp_err
	);


always @(*) begin
	if (stp_chk_en) begin
		stp_err=~sampled_bit;
	end
	else begin
		stp_err=1'b0;
	end
end
endmodule