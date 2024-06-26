/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : K-2015.06
// Date      : Fri Aug 25 03:00:42 2023
/////////////////////////////////////////////////////////////


module UART_TX_FSM ( clk, rst, data_valid, ser_done, par_en, ser_en, busy, 
        mux_sel );
  output [1:0] mux_sel;
  input clk, rst, data_valid, ser_done, par_en;
  output ser_en, busy;
  wire   n3, n5, n6, n7, n1, n4;
  wire   [2:0] cs;
  wire   [2:0] ns;

  DFFRX1M \cs_reg[0]  ( .D(ns[0]), .CK(clk), .RN(rst), .QN(n3) );
  DFFRQX2M \cs_reg[2]  ( .D(ns[2]), .CK(clk), .RN(rst), .Q(cs[2]) );
  DFFRX2M \cs_reg[1]  ( .D(ser_en), .CK(clk), .RN(rst), .Q(cs[1]), .QN(n4) );
  NOR2X2M U3 ( .A(cs[2]), .B(n4), .Y(mux_sel[1]) );
  INVX2M U4 ( .A(ser_en), .Y(mux_sel[0]) );
  NAND2X8M U5 ( .A(mux_sel[0]), .B(n7), .Y(busy) );
  NOR2X4M U6 ( .A(n3), .B(cs[2]), .Y(ser_en) );
  NOR4X1M U7 ( .A(par_en), .B(mux_sel[0]), .C(n4), .D(n1), .Y(ns[2]) );
  NAND2X2M U8 ( .A(cs[1]), .B(n3), .Y(n7) );
  OAI2BB1X2M U9 ( .A0N(data_valid), .A1N(n5), .B0(n6), .Y(ns[0]) );
  OAI2B2X1M U10 ( .A1N(cs[2]), .A0(n7), .B0(cs[2]), .B1(cs[1]), .Y(n5) );
  OAI21X2M U11 ( .A0(n4), .A1(n1), .B0(ser_en), .Y(n6) );
  INVX2M U12 ( .A(ser_done), .Y(n1) );
endmodule


module parity_calc ( p_data, data_valid, par_en, par_typ, par_bit );
  input [7:0] p_data;
  input data_valid, par_en, par_typ;
  output par_bit;
  wire   n1, n2, n3, n4, n5;

  DFFTRX2M par_bit_reg ( .D(par_en), .RN(n1), .CK(data_valid), .Q(par_bit) );
  XNOR2X2M U3 ( .A(p_data[3]), .B(p_data[2]), .Y(n4) );
  XOR3XLM U4 ( .A(par_typ), .B(n2), .C(n3), .Y(n1) );
  XOR3XLM U5 ( .A(p_data[5]), .B(p_data[4]), .C(n5), .Y(n2) );
  XOR3XLM U6 ( .A(p_data[1]), .B(p_data[0]), .C(n4), .Y(n3) );
  XNOR2X2M U7 ( .A(p_data[7]), .B(p_data[6]), .Y(n5) );
endmodule


module mux_4_to_1 ( sel, s2, s3, mux_out );
  input [1:0] sel;
  input s2, s3;
  output mux_out;
  wire   n5, n2, n3, n4;

  NOR2BX2M U3 ( .AN(sel[1]), .B(s3), .Y(n2) );
  CLKBUFX8M U4 ( .A(n5), .Y(mux_out) );
  INVX2M U5 ( .A(sel[0]), .Y(n4) );
  NAND3X2M U6 ( .A(s2), .B(n4), .C(sel[1]), .Y(n3) );
  OAI21X2M U7 ( .A0(n2), .A1(n4), .B0(n3), .Y(n5) );
endmodule


module serializer ( p_data, ser_en, clk, rst, out_data, ser_done );
  input [7:0] p_data;
  input ser_en, clk, rst;
  output out_data, ser_done;
  wire   N1, N2, N3, \counter[3] , N8, N13, N14, N15, N16, N18, n6, n7, n8, n9,
         n1, n2, n3, n4, n5, n10;

  DFFSQX2M out_data_reg ( .D(N13), .CK(clk), .SN(rst), .Q(out_data) );
  DFFRX1M ser_done_reg ( .D(N18), .CK(clk), .RN(rst), .Q(ser_done) );
  DFFRX1M \counter_reg[3]  ( .D(n1), .CK(clk), .RN(rst), .Q(\counter[3] ) );
  DFFRX2M \counter_reg[2]  ( .D(N16), .CK(clk), .RN(rst), .Q(N3), .QN(n5) );
  DFFRQX4M \counter_reg[0]  ( .D(N14), .CK(clk), .RN(rst), .Q(N1) );
  DFFRQX4M \counter_reg[1]  ( .D(N15), .CK(clk), .RN(rst), .Q(N2) );
  MX4XLM U3 ( .A(p_data[0]), .B(p_data[1]), .C(p_data[2]), .D(p_data[3]), .S0(
        N1), .S1(N2), .Y(n4) );
  MX4XLM U4 ( .A(p_data[4]), .B(p_data[5]), .C(p_data[6]), .D(p_data[7]), .S0(
        N1), .S1(N2), .Y(n3) );
  XNOR2X1M U5 ( .A(N1), .B(N2), .Y(n9) );
  INVX2M U6 ( .A(n8), .Y(n10) );
  OR2X2M U7 ( .A(N8), .B(n10), .Y(N13) );
  MX2X2M U8 ( .A(n4), .B(n3), .S0(N3), .Y(N8) );
  NOR2BX4M U9 ( .AN(ser_en), .B(ser_done), .Y(n8) );
  AOI2B1X2M U10 ( .A1N(N2), .A0(n8), .B0(N14), .Y(n7) );
  NOR2X2M U11 ( .A(n10), .B(N1), .Y(N14) );
  AO21XLM U12 ( .A0(n2), .A1(\counter[3] ), .B0(N18), .Y(n1) );
  OAI21X2M U13 ( .A0(n10), .A1(N3), .B0(n7), .Y(n2) );
  NOR3X4M U14 ( .A(n6), .B(\counter[3] ), .C(n5), .Y(N18) );
  OAI22X1M U15 ( .A0(n7), .A1(n5), .B0(N3), .B1(n6), .Y(N16) );
  NAND3X2M U16 ( .A(N1), .B(n8), .C(N2), .Y(n6) );
  NOR2X2M U17 ( .A(n9), .B(n10), .Y(N15) );
endmodule


module top_module ( p_data, data_valid, par_en, par_typ, clk, rst, tx_out, 
        busy );
  input [7:0] p_data;
  input data_valid, par_en, par_typ, clk, rst;
  output tx_out, busy;
  wire   ser_done, ser_en, par_bit, ser_data;
  wire   [1:0] mux_sel;

  UART_TX_FSM FSM ( .clk(clk), .rst(rst), .data_valid(data_valid), .ser_done(
        ser_done), .par_en(par_en), .ser_en(ser_en), .busy(busy), .mux_sel(
        mux_sel) );
  parity_calc par_calc ( .p_data(p_data), .data_valid(data_valid), .par_en(
        par_en), .par_typ(par_typ), .par_bit(par_bit) );
  mux_4_to_1 mux ( .sel(mux_sel), .s2(ser_data), .s3(par_bit), .mux_out(tx_out) );
  serializer serializer_unit ( .p_data(p_data), .ser_en(ser_en), .clk(clk), 
        .rst(rst), .out_data(ser_data), .ser_done(ser_done) );
endmodule

