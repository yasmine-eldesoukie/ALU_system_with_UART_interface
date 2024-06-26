`timescale 1us/100ns
module alu_top_tb # (parameter WIDTH =16);
//signal declaration
reg [WIDTH-1:0] a_tb, b_tb;
reg [3:0] func_tb;
reg clk, rst_tb;
wire [WIDTH-1:0] arith_out_dut, logic_out_dut, cmp_out_dut, shift_out_dut ;
wire carry_out_dut, arith_flag_dut, logic_flag_dut, cmp_flag_dut, shift_flag_dut;

reg [WIDTH-1:0] arith_out_expected, logic_out_expected, cmp_out_expected, shift_out_expected;
reg carry_out_expected, arith_flag_expected, logic_flag_expected, cmp_flag_expected, shift_flag_expected;

//instantiation
alu_top #(WIDTH) dut (
	.a(a_tb),
	.b(b_tb),
	.alu_func(func_tb),
	.clk(clk),
	.rst(rst_tb),
	.arith_out(arith_out_dut),
	.carry_out(carry_out_dut),
	.arith_flag(arith_flag_dut),
	.logic_out(logic_out_dut),
	.logic_flag(logic_flag_dut),
	.cmp_out(cmp_out_dut),
	.cmp_flag(cmp_flag_dut),
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
integer i,j;
initial begin
	$dumpfile("alu top");
	$dumpvars; 
	a_tb=0;
	b_tb=0;
	func_tb=4'b0;
	//---------------------------- reset on  ---------------------------
	rst_tb=0;
	repeat (30) @(negedge clk);


	             //reset should dominate and all dut outputs should be zeros
	for (i=0; i<100; i=i+1) begin
	    @(negedge clk);
		func_tb=$random;
		a_tb=$random;
		b_tb=$random;
    end

    //---------------------------- reset off  ----------------------------

    @(negedge clk);
	rst_tb=1;
    for (i=0; i<2500 ; i=i+1) begin

        // // // // // // // // generating inputs // // // // // // // //

		    //////////////////////////////////////// arithmetic  //////////////////////////////////////// 
            if (i<500) begin 
            	//generating j for the following if conditions 
            	if(i==0) //the first value is 0 and it's used to set j back to 0
            	    j=0;
            	else
            	    j=j+1'd1; 

            	func_tb[3:2]=2'b00;
            	// ....................... addition .......................
            	if (j<100) begin
            		func_tb[1:0]=2'b00;
			        a_tb=$random;
			        b_tb=$random;
            	end

            	// ....................... subtraction .......................
            	else if (j<200) begin
            		func_tb[1:0]=2'b01;
			        a_tb=$random;
			        b_tb=$random;
            	end

            	// ....................... multiplication .......................
            	else if (j<300) begin
            		func_tb[1:0]=2'b10;
			        a_tb=$random;
			        b_tb=$random;
            	end

            	// ....................... division .......................
            	else if (j<400) begin
            		func_tb[1:0]=2'b11;
			        a_tb=$random;
			        b_tb=$random;
            	end

            	// ....................... random operation .......................
            	else  begin
            		func_tb[1:0]=$random;
			        a_tb=$random;
			        b_tb=$random;
            	end
            end

            ////////////////////////////////////////   logic    //////////////////////////////////////// 
            else if (i<1000) begin 
            	if(i==500) 
            	    j=0;
            	else
            	    j=j+1; 

            	func_tb[3:2]=2'b01;
            	// ....................... AND .......................
            	if (j<100) begin
            		func_tb[1:0]=2'b00;
			        a_tb=$random;
			        b_tb=$random;
            	end

            	// ....................... OR .......................
            	else if (j<200) begin
            		func_tb[1:0]=2'b01;
			        a_tb=$random;
			        b_tb=$random;
            	end

            	// ....................... NAND .......................
            	else if (j<300) begin
            		func_tb[1:0]=2'b10;
			        a_tb=$random;
			        b_tb=$random;
            	end

            	// ....................... NOR .......................
            	else if (j<400) begin
            		func_tb[1:0]=2'b11;
			        a_tb=$random;
			        b_tb=$random;
            	end

            	// ....................... random operation .......................
            	else begin
            		func_tb[1:0]=$random;
			        a_tb=$random;
			        b_tb=$random;
            	end
            end

            ////////////////////////////////////////    cmp    //////////////////////////////////////// 
            else if (i<1500) begin 
            	if(i==1000) 
            	    j=0;
            	else
            	    j=j+1'd1; 

            	func_tb[3:2]=2'b10;
            	// ....................... NOP .......................
            	if (j<100) begin
            		func_tb[1:0]=2'b00;
			        a_tb=$random;
			        b_tb=$random;
            	end

            	// ....................... equal .......................
            	else if (j<200) begin
            		func_tb[1:0]=2'b01;
			        a_tb=$random;
			        b_tb=$random;
            	end

            	// ....................... greater .......................
            	else if (j<300) begin
            		func_tb[1:0]=2'b10;
			        a_tb=$random;
			        b_tb=$random;
            	end

            	// ....................... smaller .......................
            	else if (j<400) begin
            		func_tb[1:0]=2'b11;
			        a_tb=$random;
			        b_tb=$random;
            	end

            	// ....................... random operation .......................
            	else begin
            		func_tb[1:0]=$random;
			        a_tb=$random;
			        b_tb=$random;
            	end
            end

            ////////////////////////////////////////   shift  //////////////////////////////////////// 
            else if (i<2000) begin 
            	if(i==1500) 
            	    j=0;
            	else
            	    j=j+1'd1; 

            	func_tb[3:2]=2'b11;
            	// ....................... a>> .......................
            	if (j<100) begin
            		func_tb[1:0]=2'b00;
			        a_tb=$random;
			        b_tb=$random;
            	end

            	// ....................... a<< .......................
            	else if (j<200) begin
            		func_tb[1:0]=2'b01;
			        a_tb=$random;
			        b_tb=$random;
            	end

            	// ....................... b>> .......................
            	else if (j<300) begin
            		func_tb[1:0]=2'b10;
			        a_tb=$random;
			        b_tb=$random;
            	end

            	// ....................... b<< .......................
            	else if (j<400) begin
            		func_tb[1:0]=2'b11;
			        a_tb=$random;
			        b_tb=$random;
            	end

            	// ....................... random operation .......................
            	else begin
            		func_tb[1:0]=$random;
			        a_tb=$random;
			        b_tb=$random;
            	end
            end

            //////////////////////////////////////// random unit  //////////////////////////////////////// 
            else begin
            	 func_tb=$random;
			     a_tb=$random;
			     b_tb=$random;
            end

		// // // // // // // // expected outputs // // // // // // // //
            arith_out_expected ='d0;
		    carry_out_expected ='d0;
			arith_flag_expected='d0;
			logic_out_expected ='d0;
			logic_flag_expected='d0;
			cmp_out_expected   ='d0;
			cmp_flag_expected  ='d0;
			shift_out_expected ='d0;
			shift_flag_expected='d0;

			case (func_tb) 
			4'b0000: begin
                {carry_out_expected, arith_out_expected}=a_tb + b_tb;		        
			    arith_flag_expected=1'b1;
			end
			4'b0001: begin
                arith_out_expected =a_tb - b_tb;		        
			    arith_flag_expected=1'b1;
			end
			4'b0010: begin
                arith_out_expected =a_tb * b_tb;		        
			    arith_flag_expected=1'b1;
			end
			4'b0011: begin
                arith_out_expected =a_tb / b_tb;		        
			    arith_flag_expected=1'b1;
			end
            ////////////////////////////////////////////////////////
            4'b0100: begin
                logic_out_expected =a_tb & b_tb;		        
			    logic_flag_expected=1'b1;
			end
			4'b0101: begin
                logic_out_expected =a_tb | b_tb;		        
			    logic_flag_expected=1'b1;
			end
			4'b0110: begin
                logic_out_expected = ~(a_tb & b_tb);		        
			    logic_flag_expected=1'b1;
			end
			4'b0111: begin
                logic_out_expected = ~(a_tb | b_tb);		        
			    logic_flag_expected=1'b1;
			end
			////////////////////////////////////////////////////////
            4'b1000: begin
                cmp_out_expected ='d0;		        
			    cmp_flag_expected=1'b1;
			end
			4'b1001: begin
                cmp_out_expected =(a_tb==b_tb)?  1: 0;		        
			    cmp_flag_expected=1'b1;
			end
			4'b1010: begin
                cmp_out_expected =(a_tb > b_tb)? 2: 0;		        
			    cmp_flag_expected=1'b1;
			end
			4'b1011: begin
                cmp_out_expected =(a_tb < b_tb)? 3: 0;		        
			    cmp_flag_expected=1'b1;
			end
			////////////////////////////////////////////////////////
            4'b1100: begin
                shift_out_expected =a_tb >> 1;		        
			    shift_flag_expected=1'b1;
			end
			4'b1101: begin
                shift_out_expected =a_tb << 1;		        
			    shift_flag_expected=1'b1;
			end
			4'b1110: begin
                shift_out_expected =b_tb >> 1;		        
			    shift_flag_expected=1'b1;
			end
			4'b1111: begin
                shift_out_expected =b_tb << 1;		        
			    shift_flag_expected=1'b1;
			end
			endcase

		// // // // // // // // checking // // // // // // // //

            @(negedge clk); //delay in the for loop is before checking so that the dut have enough time to be also updated

            // ................ arithmetic ................
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

			// ................ logic ................
			if (logic_out_expected!= logic_out_dut) begin
				$display("logic_out WRONG");
				$stop;
			end
			if (logic_flag_expected!= logic_flag_dut) begin
				$display("logic_flag WRONG");
				$stop;
			end

			 // ................ cmp ................
			if (cmp_out_expected!= cmp_out_dut) begin
				$display("cmp_out WRONG");
				$stop;
			end
			if (cmp_flag_expected!= cmp_flag_dut) begin
				$display("cmp_flag WRONG");
				$stop;
			end

			// ................ shift ................
			if (shift_out_expected!= shift_out_dut) begin
				$display("shift_out WRONG");
				$stop;
			end
			if (shift_flag_expected!= shift_flag_dut) begin
				$display("shift_flag WRONG");
				$stop;
			end
    
    end //for loop

    //---------------------------- reset on ----------------------------
                      //all dut outputs should be zero
    @(negedge clk);
    rst_tb=0;

    repeat (30) @(negedge clk);
    $stop;

end //initial

endmodule
