module serializer (
input wire [7:0] p_data,
input wire ser_en, clk, rst, 
output reg out_data, ser_done
);
reg [3:0] counter;

/*always @(posedge clk or negedge rst) begin
   if (!rst) begin
	   counter<=4'b0000;
       ser_done<=1'b0;
   end
   else if (ser_en) begin
       if (counter==8)
          ser_done<=1'b1;
       else 
          ser_done<=1'b0;
       counter <= counter +1'b1;  
   end 
end

always @(posedge clk or negedge rst) begin
if (!rst)
     out_data<=1'b1;
else if (ser_en & !ser_done) begin
     out_data <= p_data [counter];
     $display("data %d:", counter);
     end
else begin
     out_data<=1'b1;
     $display("one");
     end
end
*/
always @(posedge clk or negedge rst) begin
    if (!rst) begin
	    out_data<=1'b1;
        counter<=4'b0000;
        ser_done<=1'b0;
    end
    else if (ser_en & !ser_done) begin
        out_data <= p_data [counter];
        counter  <= counter+1'b1;
        if (counter==7) 
           ser_done<=1'b1;
        else 
           ser_done<=1'b0;
    end
    else begin
     out_data<=1'b1;
     counter<=4'b0000;
     ser_done<=1'b0;
    end
end

endmodule

