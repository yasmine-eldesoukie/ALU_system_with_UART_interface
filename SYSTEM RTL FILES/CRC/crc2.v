
module crc2 #(parameter SEED=8'hd8, TAPS=7'b1000100)
(
input wire data,
input wire clk, rst, active,
output reg crc,
output reg valid
);

reg [7:0] LFSR;
reg [2:0] counter; 
reg done;

wire feedback;
assign feedback=(LFSR[0] ^ data );

integer i; 
always @(posedge clk or negedge rst) begin
	if (!rst) begin
		LFSR<=SEED;
		crc<=1'b0;
		valid<=1'b0;
		counter<=4'b0;
		done<=1; //make done =1 so that the circuit does not go in "shifting output" mode right after reset if active signal is off
	end
	else if (active) begin
		done<=0; //now once avtive is on after reset, the circuit can go to "shifting output" mode when actiive signal is off.
		for(i=0; i<7; i=i+1) begin
			if (TAPS[i]) begin
			    LFSR[i]<=(LFSR[i+1] ^ feedback);
			end
			else begin
				LFSR[i]<=LFSR[i+1];
			end
		end
		LFSR[7]<=feedback;
	end
	else if (!done) begin
		if (counter<8) begin
			{LFSR[6:0],crc} <= LFSR;
		    valid  <=1'b1;
		    counter<=counter+1;
		end
		else begin
			done <=1;
			crc  <=1'b0;
		    valid<=1'b0;
		    counter<=1'b0;
		end
	end 
		
end

endmodule 

