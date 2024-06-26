module data_sampling_tb ();
//signal declartion
reg clk,rst,enable_tb;
reg data_tb;
reg [4:0] prescale_tb, edge_count_tb;
wire sampled_bit_dut;

reg [31:0] data_reg;
reg [6:0] sampled_reg;
reg sampled_bit_expec;

//instantiation
data_sampling dut (
	.clk(clk),
	.rst(rst),
	.enable(enable_tb),
	.data(data_tb),
	.prescale(prescale_tb),
	.edge_count(edge_count_tb),
	.sampled_bit(sampled_bit_dut)
);

//clk generation
initial begin
	clk=1'b0;
	forever #1 clk=~clk;
end

//stimulus generation 
integer i,j;
initial begin
	rst=1'b0;
	repeat (20) @(negedge clk);

	enable_tb=1'b1;
	for(i=7; i<32; i=i*2+1) begin
		prescale_tb=i;	

		for (j=0; j<=prescale_tb; j=j+1) begin
			edge_count_tb=j;
			data_tb=$random;
			@(negedge clk);
		end
	end

	rst=1'b1;
	enable_tb=1'b0;
	for(i=7; i<32; i=i*2+1) begin
		prescale_tb=i;

		for (j=0; j<=prescale_tb; j=j+1) begin
			edge_count_tb=j;
			data_tb=$random;
			@(negedge clk);
		end
	end

	enable_tb=1'b1;
	for(i=0; i<168; i=i+1) begin
	    if (i<8) begin
	    	prescale_tb=5'd7;
			sampled_reg=i;
			data_reg={sampled_reg,3'b0};

			for (j=0; j<=prescale_tb; j=j+1) begin
			    sampled_bit_expec=1'b0;
			    edge_count_tb=j;
			    data_tb=data_reg[j];
			    if (j!=prescale_tb) 
			      @(negedge clk);
		    end
		    casex (sampled_reg[2:0]) 
               3'b00x: sampled_bit_expec=1'b0;
               3'b0x0: sampled_bit_expec=1'b0;
               3'bx00: sampled_bit_expec=1'b0;
               default: sampled_bit_expec=1'b1;
			endcase
		    //@(negedge clk);
	    end
	    else if (i<24) begin //8+16
	    	prescale_tb=5'd15;
			sampled_reg=i-8;
			data_reg={sampled_reg,6'b0};
			
			for (j=0; j<=prescale_tb; j=j+1) begin
			    sampled_bit_expec=1'b0;
			    edge_count_tb=j;
			    data_tb=data_reg[j];
                if (j!=prescale_tb) 
			      @(negedge clk);		    
			end
		    casex (sampled_reg[4:0]) 
               5'b000xx: sampled_bit_expec=1'b0;
               5'b00xx0: sampled_bit_expec=1'b0;
               5'b0xx00: sampled_bit_expec=1'b0;
               5'bxx000: sampled_bit_expec=1'b0;

               5'b00x0x: sampled_bit_expec=1'b0;
               5'b0x0x0: sampled_bit_expec=1'b0;
               5'bx0x00: sampled_bit_expec=1'b0;

               5'b0x00x: sampled_bit_expec=1'b0;
               5'bx00x0: sampled_bit_expec=1'b0;

               5'bx000x: sampled_bit_expec=1'b0;
               default: sampled_bit_expec=1'b1;
			endcase
		    //@(negedge clk);
	    end
	    else begin
	    	prescale_tb=5'd31;
			sampled_reg=i-24;
			data_reg={sampled_reg,13'b0};

			for (j=0; j<=prescale_tb; j=j+1) begin
			    sampled_bit_expec=1'b0;
			    edge_count_tb=j;
			    data_tb=data_reg[j];
                if (j!=prescale_tb) 
			      @(negedge clk);		   
			end
		    casex (sampled_reg) 
               7'b0000xxx: sampled_bit_expec=1'b0;
               7'b000xxx0: sampled_bit_expec=1'b0;
               7'b00xxx00: sampled_bit_expec=1'b0;
               7'b0xxx000: sampled_bit_expec=1'b0;
               7'bxxx0000: sampled_bit_expec=1'b0;

               7'b000x0xx: sampled_bit_expec=1'b0;
               7'b00x0xx0: sampled_bit_expec=1'b0;
               7'b0x0xx00: sampled_bit_expec=1'b0;
               7'bx0xx000: sampled_bit_expec=1'b0;

               7'b00x00xx: sampled_bit_expec=1'b0;
               7'b0x00xx0: sampled_bit_expec=1'b0;
               7'bx00xx00: sampled_bit_expec=1'b0;

               7'b0x000xx: sampled_bit_expec=1'b0;
               7'bx000xx0: sampled_bit_expec=1'b0;

               7'bx0000xx: sampled_bit_expec=1'b0;

               7'b000xx0x: sampled_bit_expec=1'b0;
               7'b00xx0x0: sampled_bit_expec=1'b0;
               7'b0xx0x00: sampled_bit_expec=1'b0;
               7'bxx0x000: sampled_bit_expec=1'b0;

               7'b00xx00x: sampled_bit_expec=1'b0;
               7'b0xx00x0: sampled_bit_expec=1'b0;
               7'bxx00x00: sampled_bit_expec=1'b0;

               7'b0xx000x: sampled_bit_expec=1'b0;
               7'bxx000x0: sampled_bit_expec=1'b0;

               7'bxx0000x: sampled_bit_expec=1'b0;

               7'b00x0x0x: sampled_bit_expec=1'b0;
               7'b0x0x0x0: sampled_bit_expec=1'b0;
               7'bx0x0x00: sampled_bit_expec=1'b0;

               7'b0x0x00x: sampled_bit_expec=1'b0;
               7'bx0x00x0: sampled_bit_expec=1'b0;

               7'bx0x000x: sampled_bit_expec=1'b0;

               7'b0x00x0x: sampled_bit_expec=1'b0;
               7'bx00x0x0: sampled_bit_expec=1'b0;

               7'bx000x0x: sampled_bit_expec=1'b0;

               7'bx00x00x: sampled_bit_expec=1'b0;

               default: sampled_bit_expec=1'b1;
			endcase
		    //@(negedge clk);
	    end

	   if (sampled_bit_dut!=sampled_bit_expec) begin
	    	$display("ERROR");
	    	$stop;
	   end
	   @(negedge clk);
	end
	@(negedge clk);
	    $stop;
  
end
endmodule
