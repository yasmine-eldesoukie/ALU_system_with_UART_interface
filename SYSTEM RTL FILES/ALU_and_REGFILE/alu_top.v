module alu_top #(parameter WIDTH=16)
(
 input wire [WIDTH-1:0] a,b,
 input wire [3:0] alu_func,
 input wire clk, rst,
 output wire [WIDTH-1:0] arith_out, logic_out, shift_out, cmp_out,
 output wire carry_out, arith_flag , logic_flag , shift_flag , cmp_flag
);

//internal signals
wire arith_enable, logic_enable , cmp_enable , shift_enable;
//instantiation
////////////////////// decoder //////////////////////
decoder_2_to_4 alu_dec (
	.dec_in(alu_func[3:2]),
	.d0(arith_enable),
	.d1(logic_enable),
	.d2(cmp_enable),
	.d3(shift_enable)
	);
////////////////////// arithmetic unit //////////////////////
arithmetic_unit #(WIDTH) inst_arith_unit (
	.a(a),
	.b(b),
	.func(alu_func[1:0]),
	.clk(clk),
	.rst(rst),
	.enable(arith_enable),
	.arith_out(arith_out),
	.carry_out(carry_out),
	.arith_flag(arith_flag)
	);
////////////////////// logic unit //////////////////////
logic_unit #(WIDTH) inst_logic_unit (
	.a(a),
	.b(b),
	.func(alu_func[1:0]),
	.clk(clk),
	.rst(rst),
	.enable(logic_enable),
	.logic_out(logic_out),
	.logic_flag(logic_flag)
	);
////////////////////// cmp unit //////////////////////
cmp_unit #(WIDTH) inst_cmp_unit (
	.a(a),
	.b(b),
	.func(alu_func[1:0]),
	.clk(clk),
	.rst(rst),
	.enable(cmp_enable),
	.cmp_out(cmp_out),
	.cmp_flag(cmp_flag)
	);
////////////////////// shift unit //////////////////////
shift_unit #(WIDTH) inst_shift_unit (
	.a(a),
	.b(b),
	.func(alu_func[1:0]),
	.clk(clk),
	.rst(rst),
	.enable(shift_enable),
	.shift_out(shift_out),
	.shift_flag(shift_flag)
	);

endmodule