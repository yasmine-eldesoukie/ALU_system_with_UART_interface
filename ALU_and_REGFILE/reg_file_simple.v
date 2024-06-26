module reg_file #(parameter WIDTH =16 , LINES=8)
(
  input wire [WIDTH-1:0] wr_data,
  input wire [$clog2(LINES)-1:0] addr,
  input wire wr_en,rd_en,clk,rst,
  output reg [WIDTH-1:0] rd_data
	);

reg [WIDTH-1:0] regfile [LINES-1:0] ;

integer i;
always @(posedge clk or negedge rst) begin
	if (!rst) begin
		for (i=0 ; i<LINES ; i=i+1) begin
			regfile[i]='d0;
		end
	end
	else begin
		case ({wr_en,rd_en})
            2'b10: regfile[addr]<=wr_data;
            2'b01: rd_data<=regfile[addr];
            default: rd_data<='d0;
        endcase
	end 
end
endmodule

