`timescale 1us/100ns
module arithmetic_unit_tb # (parameter WIDTH =16);
//signal declaration
reg [WIDTH-1:0] a_tb, b_tb;
reg [1:0] func_tb;
reg clk, rst_tb, enable_tb;
wire [WIDTH-1:0] arith_out_dut;
wire carry_out_dut, arith_flag_dut;

reg [WIDTH-1:0] arith_out_expected;
reg carry_out_expected, arith_flag_expected;

//instantiation
arithmetic_unit #(WIDTH) dut (
	.a(a_tb),
	.b(b_tb),
	.func(func_tb),
	.clk(clk),
	.rst(rst_tb),
	.enable(enable_tb),
	.arith_out(arith_out_dut),
	.carry_out(carry_out_dut),
	.arith_flag(arith_flag_dut) );

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
	$dumpfile("arithmetic unit");
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
			arith_flag_expected=1;
			if (func_tb==2'b00) 
			    {carry_out_expected, arith_out_expected}=a_tb+b_tb;
			else if (func_tb==2'b01) begin
				 arith_out_expected=a_tb-b_tb;
				 carry_out_expected=0;
			end
			else if (func_tb==2'b10) begin
				 arith_out_expected=a_tb*b_tb;
				 carry_out_expected=0;
			end
			else begin
				 arith_out_expected=a_tb/b_tb;
				 carry_out_expected=0;
			end
            @(negedge clk); //delay in the for loop is before checking so that the dut have enough time to be also updated
			if (arith_out_expected!= arith_out_dut) begin
				$display("arith_out WRONG");
				$stop;
			end
			if (carry_out_expected!= carry_out_dut) begin
				$display("carry_out WRONG");
				$stop;
			end
			if (arith_flag_expected!= arith_flag_dut) begin
				$display("arith_flag WRONG");
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