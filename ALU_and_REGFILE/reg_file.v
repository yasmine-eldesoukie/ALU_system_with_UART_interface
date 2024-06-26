module reg_file 
#(parameter 
	WIDTH=8,
	LINES=4,
	DEPTH=16,
	CONFIG={1'b0,5'd31,1'b0,1'b1}
)
(
  input wire clk,rst,wr_en,rd_en,
  input wire [WIDTH-1:0] wr_data,
  input wire [LINES-1:0] addr,
  output reg [WIDTH-1:0] rd_data, reg0, reg1, reg2, 
  output reg rd_valid
);

//note: i didn't use reg3 to save the div_ratio as i made a specific clk_div block of a fixed ratio that can be changed via a parameter

// clk,rst,wr_en,rd_en,wr_data,addr,rd_data, reg0, reg1, reg1, reg3,rd_valid

reg [WIDTH-1:0] regfile [DEPTH-1:0] ;

integer i;
always @(posedge clk or negedge rst) begin
	if (!rst) begin
	    rd_valid<=1'b0;
	    rd_data<= 'b0;
		for (i=0 ; i<DEPTH ; i=i+1) begin
			if (i==2) begin
				regfile[i]<=CONFIG;
			end
			else begin
				regfile[i]<='d0;
			end
		end
	end

	else begin
	    rd_valid<=1'b0;
		case ({wr_en,rd_en})
            2'b10: begin
            	regfile[addr]<=wr_data;
            end 
            2'b01: begin
          	    rd_valid<=1'b1;
                rd_data<=regfile[addr];
            end 
            default: begin
            	rd_data<='b0;
            	rd_valid<=1'b0;
            end 
        endcase
	end 
end

always @(*) begin
	reg0=regfile[0];
	reg1=regfile[1];
	reg2=regfile[2];
end
endmodule

