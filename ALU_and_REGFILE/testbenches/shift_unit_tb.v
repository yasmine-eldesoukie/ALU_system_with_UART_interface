`timescale 1us/100ns
module shift_unit_tb # (parameter WIDTH =16);
//signal declaration
reg [WIDTH-1:0] a_tb, b_tb;
reg [1:0] func_tb;
reg clk, rst_tb, enable_tb;
wire [WIDTH-1:0] shift_out_dut;
wire shift_flag_dut;

reg [WIDTH-1:0] shift_out_expected;
reg shift_flag_expected;

//instantiation
shift_unit #(WIDTH) dut (
	.a(a_tb),
	.b(b_tb),
	.func(func_tb),
	.clk(clk),
	.rst(rst_tb),
	.enable(enable_tb),
	.shift_out(shift_out_dut),
	.shift_flag(shift_flag_dut) );

//clock generation
initial begin
	clk=0;
	forever begin
		#4 clk=1;
		#6 clk=0;
	end
end

//stimulus generation
integer i;
initial begin
	$dumpfile("shift unit");
	$dumpvars; 
	a_tb=0;
	b_tb=0;
	//////////////////// reset on and enable off ////////////////////
	enable_tb=0;
	rst_tb=0;
	#50

	//////////////////// reset and enable on ////////////////////

	//reset should dominate and all outputs should be zeros
	enable_tb=1;
	for (i=0; i<100; i=i+1) begin
	    @(negedge clk);
		func_tb=$random;
		a_tb=$random;
		b_tb=$random;
    end

    //////////////////// rest is off and enable is on ////////////////////
    @(negedge clk);
	rst_tb=1;
    for (i=0; i<1000 ; i=i+1) begin
		    //@(negedge clk);   
            func_tb=$random;
			a_tb=$random;
			b_tb=$random;
			//checking
			shift_flag_expected=1;
			if (func_tb==2'b00) 
			     shift_out_expected=a_tb>>1;
			else if (func_tb==2'b01) begin
			     shift_out_expected=a_tb<<1;
			end
			else if (func_tb==2'b10) begin
			     shift_out_expected=b_tb>>1;
			end
			else begin
			     shift_out_expected=b_tb<<1;
			end
            @(negedge clk); //delay in the for loop is before checking so that the dut have enough time to be also updated
			if (shift_out_expected!= shift_out_dut) begin
				$display("shift_out WRONG");
				$stop;
			end
			if (shift_flag_expected!= shift_flag_dut) begin
				$display("shift_flag WRONG");
				$stop;
			end

	end

    //////////////////// reset and enable off ////////////////////
    //all outputs should be zero
    @(negedge clk);
    enable_tb=0;
    for (i=0; i<100; i=i+1) begin
	    @(negedge clk)
		func_tb=$random;
		a_tb=$random;
		b_tb=$random;
    end

    @(negedge clk);
    $stop;

end //initial


endmodule