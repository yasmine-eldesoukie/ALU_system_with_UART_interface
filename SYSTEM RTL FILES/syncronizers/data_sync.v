module data_sync 
#(parameter 
   BUS_WIDTH=8,
   NUM_STAGES=2
)
(
	input wire clk, rst, async_data_en, //async_en is the bus_enable
	input wire [BUS_WIDTH-1:0] async_data,
	output reg [BUS_WIDTH-1:0] sync_data,
	output reg sync_data_en //enable_pulse
 );

wire sync_en; //sync data enable signal after bit_sync "multi flip flop"
wire pulse;  //pulse_gen output signal

//instantiation
bit_sync #(.NUM_STAGES(NUM_STAGES)) data_sync_bit_sync (
	.clk(clk),
	.rst(rst),
	.async(async_data_en),
	.sync(sync_en)
);

pulse_gen data_sync_pulse_gen (
	.clk(clk),
	.rst(rst),
	.in(sync_en),
	.pulse(pulse)
);

//sync_data 
always @(posedge clk or negedge rst) begin
	if (!rst) begin
		sync_data<= 'b0;
	end
	else if (pulse) begin
		sync_data<=async_data;
    end
end

//sync_data_en
always @(posedge clk or negedge rst) begin
	if (!rst) begin
		sync_data_en<=1'b0;
	end
	else begin
		sync_data_en<=pulse;
    end
end
endmodule

//NOTE: data_sync will be (2 "bit_sync"+ 1 "pulse_gen F.F" + 1 "output F.F"), --> 4 ref clks