`timescale 1us/100ns
module cmp_unit_tb # (parameter WIDTH =16);
//signal declaration
reg [WIDTH-1:0] a_tb, b_tb;
reg [1:0] func_tb;
reg clk, rst_tb, enable_tb;
wire [WIDTH-1:0] cmp_out_dut;
wire cmp_flag_dut;

reg [WIDTH-1:0] cmp_out_expected;
reg cmp_flag_expected;

//instantiation
cmp_unit #(WIDTH) dut (
	.a(a_tb),
	.b(b_tb),
	.func(func_tb),
	.clk(clk),
	.rst(rst_tb),
	.enable(enable_tb),
	.cmp_out(cmp_out_dut),
	.cmp_flag(cmp_flag_dut) );

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
	$dumpfile("cmp unit");
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
			cmp_flag_expected=1;
			if (func_tb==2'b00) 
			     cmp_out_expected= 'd0 ;
			else if (func_tb==2'b01) begin
			     cmp_out_expected=(a_tb==b_tb)? 1:0 ;
			end
			else if (func_tb==2'b10) begin
			     cmp_out_expected=(a_tb>b_tb)? 2:0 ;
			end
			else begin
			     cmp_out_expected=(a_tb<b_tb)? 3:0 ;
			end
            @(negedge clk); //delay in the for loop is before checking so that the dut have enough time to be also updated
			if (cmp_out_expected!= cmp_out_dut) begin
				$display("cmp_out WRONG");
				$stop;
			end
			if (cmp_flag_expected!= cmp_flag_dut) begin
				$display("cmp_flag WRONG");
				$stop;
			end

	end

    //////////////////// reset and enable off ////////////////////
    //all outputs should be zero
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