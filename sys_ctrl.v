module sys_ctrl 
#(parameter
	ALU_WIDTH=16,
	ALU_FUN_WIDTH=4,
	ADDRESS=4,
	DATA_WIDTH=8,

	//states
	IDLE = 4'b0000, //0 // >> WAIT states

    WAIT_WR_ADDR = 4'b0001, //1
    WR_ADDR = 4'b0011, //3
    WAIT_WR_DATA = 4'b0111,//7
    WR_DATA = 4'b0101,//5

    WAIT_RD_ADDR = 4'b0010,//2
    RD_ADDR = 4'b1010,//10
    FIFO = 4'b1000, //8  //fifo differs from idle by 1 bit because this transition occurs often 

    WAIT_OPERAND = 4'b0100,//4
    OP_1 = 4'b1100,//12
    OP_2 = 4'b0110,//6
    WAIT_ALU_FUN= 4'b1110,//14
    ALU_FUN = 4'b1111,//15
    ALU_OUT = 4'b1011 //11
)
(
	input wire clk, rst, 
	input wire alu_valid, rx_d_valid, rd_d_valid, full,
	input wire [ALU_WIDTH-1:0] alu_out, 
    input wire [DATA_WIDTH-1:0] rx_p_data, rd_data,
	output reg alu_en, clk_en, wr_en, rd_en, wr_inc,
	output reg [ALU_FUN_WIDTH-1:0] alu_fun,
	output reg [ADDRESS-1:0] addr,
	output reg  [DATA_WIDTH-1:0] wr_data, fifo_p_data
);

// clk, rst,alu_valid, rx_d_valid, rd_d_valid, full, alu_out, rx_p_data, rd_data,alu_en, clk_en, wr_en, rd_en, wr_inc,alu_fun,addr,wr_data, fifo_p_data

reg [3:0] cs, ns;
reg op_1, rd_regfile, one_more;

always @(posedge clk or negedge rst) begin
	if (!rst) begin
		cs<= IDLE;
	end
	else begin
		cs<=ns;
	end
end
 
always @(*) begin
	case (cs)
        IDLE: begin
        	if (rx_d_valid & rx_p_data == 8'hAA) begin
        		ns = WAIT_WR_ADDR;
        	end
        	else if (rx_d_valid & rx_p_data == 8'hBB) begin
        		ns = WAIT_RD_ADDR;
        	end
        	else if (rx_d_valid & rx_p_data==8'hCC ) begin
        		ns = WAIT_OPERAND;
        	end
        	else if (rx_d_valid & rx_p_data==8'hDD) begin
        		ns = WAIT_ALU_FUN; 
        	end
        	else begin
        		ns = IDLE;
        	end
        end
    // ----- Write in RegFile -----
        WAIT_WR_ADDR: begin
        	if (rx_d_valid) begin
        		ns = WR_ADDR;
        	end
        	else begin
        		ns = WAIT_WR_ADDR;
        	end
        end

        WR_ADDR: begin
        	ns = WAIT_WR_DATA;
        end

        WAIT_WR_DATA: begin
        	if (rx_d_valid) begin
        		ns = WR_DATA;
        	end
        	else begin
        		ns = WAIT_WR_DATA;
        	end
        end

        WR_DATA: begin
        	ns= IDLE;
        end

    // ----- Read from RegFile -----
        WAIT_RD_ADDR: begin
        	if (rx_d_valid) begin
        		ns = RD_ADDR;
        	end
        	else begin
        		ns = WAIT_RD_ADDR;
        	end
        end

        RD_ADDR: begin
        	if (!full) begin
                ns = FIFO;
            end
            else begin
                ns = IDLE;
            end
        end

        
        FIFO: begin
            if (one_more) begin
            	ns = FIFO;
            end
            else begin
            	ns = IDLE;
            end
        end

    // ----- ALU -----
        WAIT_OPERAND: begin
        	if (rx_d_valid & op_1) begin
        		ns = OP_1;
        	end
        	else if (rx_d_valid & !op_1) begin
        		ns = OP_2;
        	end
        	else begin
        		ns = WAIT_OPERAND;
        	end
        end

        OP_1: begin
        	ns=WAIT_OPERAND;
        end


        OP_2: begin
        	ns = WAIT_ALU_FUN;
        end

        WAIT_ALU_FUN: begin
        	if (rx_d_valid) begin
        		ns = ALU_FUN;
        	end
        	else begin
        		ns = WAIT_ALU_FUN;
        	end
        end

        ALU_FUN: begin
            ns = ALU_OUT;
        end

        ALU_OUT: begin
        	if (alu_valid & !full) begin
        		ns = FIFO;
        	end
        	else begin
        		ns = ALU_OUT;
        	end
        end

        default: begin
            ns= IDLE;
        end
        endcase
end


//internal signal
always @(*) begin
    if (cs==IDLE) begin
        op_1=1'b0;
    end 
    else if (cs== WAIT_OPERAND & !op_1)begin
        op_1 = 1'b1; 
    end 
    else if (cs== WAIT_OPERAND)begin
        op_1 = 1'b0;
    end
    else begin
        op_1 = 1'b1;
    end
end


always @(posedge clk or negedge rst) begin
	if (!rst) begin
		one_more<=1'b0;
	end
	else if (alu_valid) begin
		one_more<=1'b1;
	end
	else begin
		one_more<=1'b0;
	end
end

//combinational output
always @(*) begin
	wr_en = (cs==OP_1 | cs==OP_2 | cs==WR_DATA);
	rd_en = (cs==RD_ADDR);
	wr_inc = (cs==FIFO);
	alu_en = (cs==ALU_FUN);
	alu_fun = (cs==ALU_FUN)? rx_p_data[3:0] : 'b0;
	wr_data= (cs==WR_DATA | cs==OP_1 | cs==OP_2)? rx_p_data : 'b0;
end

always @(*) begin
	if (cs==FIFO & rd_regfile) begin
		fifo_p_data =rd_data;
	end
	else if (cs==FIFO & !rd_regfile & one_more) begin
		fifo_p_data =alu_out[DATA_WIDTH-1:0];
	end
	else if (cs==FIFO & !rd_regfile & !one_more) begin
		fifo_p_data =alu_out[ALU_WIDTH-1:DATA_WIDTH];
	end
	else begin
		fifo_p_data = 'b0;
	end
end

//sequential outputs
//clk_en on before alu operating for a while to stable the clk, and it's off once data_valid is off which is with the start of FIFO state 
//rd_regfile is a signal to determine if fifo_wr_data will be from regFile or ALU
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        clk_en<=1'b0;
        rd_regfile<=~clk_en;
    end
    else if (cs==WAIT_ALU_FUN) begin
        clk_en<=1'b1;
        rd_regfile<=~clk_en;
    end
    else if (cs==FIFO) begin
        clk_en<=1'b0;
        rd_regfile<=~clk_en;
    end
end

//address must be saved until the wr_data is ready and wr_en on for "Write" operation in RegFile
always @(posedge clk or negedge rst) begin
	if (!rst) begin
		addr<= 'b0;
	end
	else if (cs==WR_ADDR | cs==RD_ADDR) begin
		addr<= rx_p_data[3:0];
	end
	else if (cs==WAIT_OPERAND & op_1) begin
		addr<= 'd0;
	end
	else if (cs==WAIT_OPERAND & !op_1) begin
		addr<= 'd1;
	end
end

endmodule

