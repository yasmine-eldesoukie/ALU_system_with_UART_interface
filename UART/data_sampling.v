module data_sampling (
	input wire clk,rst,enable,
	input wire data,
	input wire [4:0] prescale,
	input wire [4:0] edge_count,
	output reg sampled_bit
);

reg on,stop;
reg [2:0] counter_0,counter_1;

always @(posedge clk or negedge rst) begin
	if (!rst) begin
		counter_0<='b0;
		counter_1<='b0;
		sampled_bit<=1'b0;
	end
	else if (on & data) begin
        counter_1<=counter_1+1;
		sampled_bit<=1'b0;		
	end
	else if (on & !data) begin
        counter_0<=counter_0+1;
		sampled_bit<=1'b0;		
	end
	else if (stop) begin
		sampled_bit<=(counter_0>=counter_1)? 1'b0: 1'b1;
		counter_0<='b0;
		counter_1<='b0;
	end
	else begin
		sampled_bit<=1'b0;
	end
	
end


always @(*) begin
    if (enable & prescale==5'd7 ) begin
		    on=(edge_count>=5'd3 & edge_count<=5'd5);
		    stop=(edge_count=='d6);
		end
	else if (enable & prescale==5'd15 ) begin
		    on=(edge_count>=5'd6 & edge_count<=5'd10);
		    stop=(edge_count=='d14);
		end
	else if (enable & prescale==5'd31 ) begin
		    on=(edge_count>=5'd13 & edge_count<=5'd19);
		    stop=(edge_count=='d30);
		end
	else begin
		on=1'b0;
		stop=1'b0;
	end
end

endmodule