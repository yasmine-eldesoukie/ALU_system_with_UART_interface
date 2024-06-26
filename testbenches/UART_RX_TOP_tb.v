`timescale 1ns/1ps
module UART_RX_TOP_tb ();
//signal declaration
reg clk, rst, rx_in_tb ,par_en_tb , par_typ_tb;
reg [4:0] prescale_tb;
wire [7:0] p_data_dut;
wire data_valid_dut;

reg strt_glitch_expec, par_err_expec, stp_err_expec, data_valid_expec;

reg [2:0] x;
reg [7:0] data_reg;
reg [8:0] data_par_reg;
reg [9:0] data_par_stop_reg;
reg wrong_par,correct_par;

//instantiation
UART_RX_TOP dut (
	.clk(clk), 
	.rst(rst), 
	.rx_in(rx_in_tb),
	.par_en(par_en_tb),
	.par_typ(par_typ_tb),
	.prescale(prescale_tb),
	.p_data(p_data_dut),
	.data_valid(data_valid_dut)
	);

//clk generation
initial begin
	clk=1'b0;
	forever #(5/2) clk=~clk;
end

//stimulus generation
integer i,j;
initial begin
	rst=1'b0;
	repeat (20) @(negedge clk);

	//RX is async; it's triggered with rx_in = 0 
	//test reset dominance, rx_in = 0 with reset on
    rx_in_tb=1'b0;
	repeat (5) @(negedge clk);
    
    //test that as long as rx_in != 0 , RX is off
    //rx_in = 1 again, reset off
    rx_in_tb=1'b1;
	rst=1'b1;
    for (i=7; i<32; i=i*2+1) begin
        prescale_tb=i; 
        for (j=0; j<4; j=j+1) begin
            {par_en_tb,par_typ_tb}=j;
            repeat (prescale_tb+1) @(negedge clk);
        end   
    end

	/*
	testing start glitches : 
	rx uses a faster clk to sample rx_in data coming from a slower block, if rx_in holds a value for most of sampling points, this value will be the sampled_bit value.
    so to make a glitch, let rx_in=0 for one sampling point then 1 for the rest 
    note the 200MHz clk could 8 or 16 or 32 faster than the tx clk, this is controlled in the testbench
    */

    /*
    This part lets rx_in be 0 for 1 clk to start RX block but then sets rx_in to 1 for the rest of the clks so that data_sampling block samples a 1 
    start_check block is to detect that this is a glitch 
    
    expected: 
    strt_glitch signal 1 at edge 7
    */ 
    for (i=7; i<32; i=i*2+1) begin
        prescale_tb=i; 
        rx_in_tb=1'b0;
        @(negedge clk);  
        rx_in_tb=1'b1;
        repeat (prescale_tb) @(negedge clk);
        strt_glitch_expec=1'b1; 
        if (dut.strt_glitch!=strt_glitch_expec) begin
        	$display("start check faild at %d", i);
        	$stop;
        end
        @(negedge clk);
        strt_glitch_expec=1'b0;
    end

    $display("start check succeeded");

    /*
    This part is to set a correct start bit, some data and a wrong parity bit to check the parity_check flow
    */  

    //excpected to find par_err 1 at egde 7

      //@(negedge clk); //not needed as the last line is a delay
    par_en_tb=1'b1;
    for (i=0; i<2; i=i+1) begin
    	par_typ_tb=i;
        parity_check();
    end

    $display("parity check succeeded");
    /*
    This part is to set a correct start bit, data, parity bit if par_en on and then a wrong stop bit to check the stop_check flow
    */ 

    //excpected to find stp_err 1 at edge 7 of bit 10 if no parity/ bit 11 with parity
      //@(negedge clk);
    
    for (i=0; i<4; i=i+1) begin
    	{par_en_tb,par_typ_tb}=i;
        stop_check();
    end

    $display("stop check succeeded");


    /*
    This part is to set a correct frame to check the out flow "data_valid signal" and p_data
    */ 

    //excpected to find data_valid 1 at edge 0 "after the last bit" and p_data = the input data
      //@(negedge clk);
    
    for (i=0; i<4; i=i+1) begin
    	{par_en_tb,par_typ_tb}=i;
        out_check();
    end

    $display("out check succeeded");

    /*

    //generating configuration
	for (i=7; i<32; i=i*2+1) begin
		prescale_tb=i;
		
		for (j=0; j<400; j=j+1) begin
		    x=$random; //this determines when rx_in will be 0 to initiate communication
			if (j<100) begin
				par_en_tb=1'b0;
			end
			else if (j<200) begin
				par_en_tb=1'b1;
				par_typ_tb=1'b0;
			end
			else if (j<300) begin
				par_en_tb=1'b1;
				par_typ_tb=1'b1;
			end
			else begin
				par_en_tb=$random;
				par_typ_tb=$random;
			end

            //cases included: start glitch, parity error, stop error

            repeat (x) @(negedge clk); //to set a random time delay between the frames
            //a frame is either 10 or 11 bits
            for (k=0; k<(10+par_en_tb); k=k+1) begin
                //each bit is for a (prescale) number of clks
            	for (a=0; a<=prescale; a=a+1) begin
                     rx_in_tb=rx_in_reg[k]; 
                end
            end
            
            repeat (x) @(negedge clk); 
            rx_in_tb=1'b0;
            repeat (prescale) @(negedge clk);


		end

	end
	*/

    @(negedge clk);
    $stop;
end

////////////// parity check task //////////////
    task parity_check; 
         integer a,b,c;
         begin
   	        for (a=7; a<32; a=a*2+1) begin
                prescale_tb=a; 
            
                for (b=0; b<256; b=b+1) begin
                    rx_in_tb=1'b1;
                    x=$random;
                    repeat (x) @(negedge clk);
                    rx_in_tb=1'b0;
                    repeat (prescale_tb+2) @(negedge clk);
                    data_reg=b;
                    wrong_par=(par_typ_tb)? (^data_reg): (~^data_reg);
                    data_par_reg={wrong_par,data_reg};
        	        for (c=0; c<9; c=c+1) begin
                        rx_in_tb=data_par_reg[c];
                        repeat (prescale_tb) @(negedge clk); 
                        if (c!=8) 
                           @(negedge clk);                     
                    end
                    par_err_expec=1'b1;
                    if (dut.par_err!= par_err_expec) begin
                    	$display("parity check faild at %d",b);
                    	$stop;
                    end
                    @(negedge clk);
                    par_err_expec=1'b0;
                end
            end
         end
    endtask


    ////////////// stop check task //////////////
    task stop_check; 
         integer l,m,n;
         begin
   	        for (l=7; l<32; l=l*2+1) begin
                prescale_tb=l; 
                 
                for (m=0; m<256; m=m+1) begin
                    rx_in_tb=1'b1;
                    //x determines when the next frame starts
                    x=$random;
                    repeat (x) @(negedge clk);
                    rx_in_tb=1'b0;
                    repeat (prescale_tb+2) @(negedge clk);

                    //all different combinations of data
                    data_reg=m;
                    
                    //constructing the frame based on par_en and par_typ
                    if (par_en_tb) begin
                    	correct_par=(par_typ_tb)? (~^data_reg): (^data_reg);
                        data_par_stop_reg={1'b0,correct_par,data_reg};
                    end
                    else begin
                        correct_par=1'bx;
                        data_par_stop_reg={1'b1,1'b0,data_reg}; //last bit is dummy                   
                    end
                    
                    //assigning the bits to rx_in , each bit takes a (prescale+1) number of clks
        	        for (n=0; n<(9+par_en_tb); n=n+1) begin
                        rx_in_tb=data_par_stop_reg[n];
                        repeat (prescale_tb) @(negedge clk); 
                        if (n!=(8+par_en_tb)) 
                           @(negedge clk);
                    end

                    stp_err_expec=1'b1;
                    if (dut.stp_err!= stp_err_expec) begin
                    	$display("stop check faild at %d",m);
                    	$stop;
                    end
                    @(negedge clk);
                    stp_err_expec=1'b0;                
                end
            end
         end
    endtask

    ////////////// out check task //////////////
    task out_check; 
         integer u,v,w;
         begin
   	        for (u=7; u<32; u=u*2+1) begin
                prescale_tb=u; 
                 
                for (v=0; v<256; v=v+1) begin
                    rx_in_tb=1'b1;
                    //x determines when the next frame starts
                    x=$random;
                    repeat (x) @(negedge clk);
                    rx_in_tb=1'b0;
                    repeat (prescale_tb+2) @(negedge clk);

                    //all different combinations of data
                    data_reg=v;
                    
                    //constructing the frame based on par_en and par_typ
                    if (par_en_tb) begin
                    	correct_par=(par_typ_tb)? (~^data_reg): (^data_reg);
                        data_par_stop_reg={1'b1,correct_par,data_reg};
                    end
                    else begin
                        correct_par=1'bx;
                        data_par_stop_reg={1'b1,1'b1,data_reg}; //last bit is dummy                   
                    end
                    
                    //assigning the bits to rx_in , each bit takes a (prescale+1) number of clks
        	        for (w=0; w<(9+par_en_tb); w=w+1) begin
                        rx_in_tb=data_par_stop_reg[w];
                        repeat (prescale_tb+1) @(negedge clk); 
                    end

                    data_valid_expec=1'b1;
                    if (data_valid_dut != data_valid_expec) begin
                    	$display("out check faild at %d",v);
                    	$stop;
                    end
                    @(negedge clk);
                    stp_err_expec=1'b0;                
                end
            end
         end
    endtask

endmodule

