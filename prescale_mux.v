module prescale_mux (
	input wire [4:0] prescale,
	output reg [2:0] rx_clk_div_ratio
);

always @(*) begin
	case (prescale) 
        5'd7: begin
        	rx_clk_div_ratio= 'd4;
        end

        5'd15: begin
        	rx_clk_div_ratio= 'd2;
        end

        5'd31: begin
        	rx_clk_div_ratio= 'd1;
        end

        default:begin
        	rx_clk_div_ratio= 'd1;
        end
	endcase
end

endmodule