module bit_sync 
#(parameter 
  NUM_STAGES=2,
  BUS_WIDTH=1
)
(
	input wire clk, rst,
    input wire [BUS_WIDTH-1:0] async,
    output reg [BUS_WIDTH-1:0] sync
);

reg [NUM_STAGES-1:0] sync_reg [BUS_WIDTH-1:0];

integer i;
always @ (posedge clk or negedge rst) begin
	 if (!rst) begin
	 	for (i=0; i<BUS_WIDTH; i=i+1) begin
             sync_reg[i]<= 'b0;	 	
        end 
	 end
	 else begin
	 	for (i=0; i<BUS_WIDTH; i=i+1) begin
	 		sync_reg[i]<={async[i],sync_reg[i][NUM_STAGES-1:1]}; 
	 	end
	 end
end

always @(*) begin
	for (i=0; i<BUS_WIDTH; i=i+1) begin
		sync[i]=sync_reg[i][0];
	end
end
  
endmodule 
