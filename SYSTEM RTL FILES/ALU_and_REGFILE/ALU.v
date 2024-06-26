module ALU 
#(parameter 
     A_WIDTH =8,
     B_WIDTH =8,
     OUT_WIDTH =A_WIDTH+B_WIDTH
     )
(
input wire clk, rst, en,
input wire [A_WIDTH-1:0] A,
input wire [B_WIDTH-1:0] B,
input wire [3:0] ALU_FUN,

output reg [OUT_WIDTH-1:0] ALU_OUT,
output reg alu_valid
//output reg Arith_flag, logic_flag, CMP_flag, shift_flag
);

// clk, rst, en, A, B, ALU_FUN, ALU_OUT, alu_valid

/*
always @(*) begin
     Arith_flag= (~ALU_FUN[3] && ~ALU_FUN[2]);
     logic_flag= (ALU_FUN>4'd3 && ALU_FUN<4'd10);
     CMP_flag  = (ALU_FUN==4'd10 || ALU_FUN==4'd11 || ALU_FUN==4'd12);
     shift_flag= (ALU_FUN==13 || ALU_FUN==14 );
end
*/
always @(posedge clk or negedge rst) begin
	if (!rst) begin
      ALU_OUT<= 'b0;
      alu_valid<= 'b0;    
     end
     else if (en) begin
        alu_valid<= 1'b1;
        case(ALU_FUN)
        4'b0000: ALU_OUT<=   A + B;
        4'b0001: ALU_OUT<=   A - B;
        4'b0010: ALU_OUT<=   A * B;
        4'b0011: ALU_OUT<=   A / B;
        4'b0100: ALU_OUT<=   A & B;
        4'b0101: ALU_OUT<=   A | B;
        4'b0110: ALU_OUT<= ~(A & B);
        4'b0111: ALU_OUT<= ~(A | B);
        4'b1000: ALU_OUT<=   A ^ B;
        4'b1001: ALU_OUT<= ~(A ^ B);
        4'b1010: ALU_OUT<=  (A ==B)?  16'd1: 16'd0;
        4'b1011: ALU_OUT<=  (A > B)?  16'd2: 16'd0;
        4'b1100: ALU_OUT<=  (A < B)?  16'd3: 16'd0;
        4'b1101: ALU_OUT<=   A>>1;
        4'b1110: ALU_OUT<=   A<<1;
        default: ALU_OUT<=   16'b0;
        endcase  
     end
     else begin
          alu_valid<=1'b0;
     end    
end
endmodule