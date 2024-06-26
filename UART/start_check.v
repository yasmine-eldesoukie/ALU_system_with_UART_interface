module start_check (
	input wire strt_chk_en,
	input wire sampled_bit,
	output reg strt_glitch
	);


always @(*) begin
	if (strt_chk_en) begin
		strt_glitch=sampled_bit;
	end
	else begin
		strt_glitch=1'b0;
	end
end
endmodule