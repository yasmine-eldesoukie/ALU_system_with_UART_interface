`timescale 1ns/1ps
module crc_tb #(parameter WIDTH=8, CASES=10, PERIOD=100);
//signal declaration
reg data_tb;
reg clk, rst_tb, active_tb;
wire crc_dut, valid_dut;
//memories
reg [WIDTH-1:0] test_data [CASES-1:0];
reg [WIDTH-1:0] expec_crc [CASES-1:0];
//instatiation
crc2 dut (
	.data(data_tb),
    .clk(clk),
    .rst(rst_tb),
    .active(active_tb),
    .crc(crc_dut),
    .valid(valid_dut)
	);
//clk generation
always #(PERIOD/2) clk=~clk;

integer j;
initial begin
	$dumpfile("crc.vdc");
	$dumpvars;

	$readmemh("DATA_h.txt",test_data);
	$readmemh("Expec_Out_h.txt",expec_crc);
    
    clk=0;
    active_tb=0;

    for (j=0; j<CASES ; j=j+1) begin
    	feed_data(test_data[j]);
    	check_crc(expec_crc[j],j+1);
    end

    repeat (10) @(negedge clk);
    $stop;
end

////////////// reset task //////////////
task reset; 
   begin
   	  @(negedge clk);
      rst_tb=0;
      @(negedge clk);
      rst_tb=1;
   end
endtask

////////////// feed_data task //////////////
task feed_data;
   	input [WIDTH-1:0] data;
   	integer i;
   	begin
   		reset();
   		/*
   		comment on stalling between reset and active: 
   		---3,Aug.,2023--- don't stall between reset off and active on because the crc circuit goes straight to the "else" cond. AKA shifting output 
        ---6,Aug.,2023--- UPDATE: now a "done" signal is added to control that flow, the circuit only gets to the "shifting output" mode after active is on then off.
        */
        //to test it out, stall for one clk cycle.
        @(negedge clk);
        active_tb=1;
   		for (i=0 ; i<WIDTH ; i=i+1) begin
            data_tb=data[i];
   			@(negedge clk);
   		end
   		//@(negedge clk); //that extra cycle is wrong , only 8 are needed for the data word
        active_tb=0;
   	end
endtask
////////////// check_crc task //////////////
task check_crc;
    input [WIDTH-1:0] expec_out;
    input integer test;
    reg   [WIDTH-1:0] crc; 
    integer i;
    begin
        crc=8'bx;
    	@(posedge valid_dut);
    	for (i=0; i<WIDTH ;i=i+1) begin
            @(negedge clk); 
            //if you chance the order of the 2 lines, crc_dut is read and fed to crc twice 
            //this problem is new beacuse the delay before the for loop dep. on "valid" signal; not the negedge of clk as other testbenches
            crc[i]=crc_dut;
    	end
    	if (crc != expec_out) 
    		    $display("Test Case %d Failed",test);
        else 
                $display("Test Case %d Succeeded", test);
        $display("crc is %b",crc);

    end
endtask
endmodule
   



 
 