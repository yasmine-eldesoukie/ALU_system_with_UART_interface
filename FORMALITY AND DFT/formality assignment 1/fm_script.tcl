#### libraries ####

set SSLIB "/home/IC/Labs/Ass_Syn_2.0/std_cells/scmetro_tsmc_cl013g_rvt_ss_1p08v_125c.db"
set FFLIB "/home/IC/Labs/Ass_Syn_2.0/std_cells/scmetro_tsmc_cl013g_rvt_ff_1p32v_m40c.db"
set TTLIB "/home/IC/Labs/Ass_Syn_2.0/std_cells/scmetro_tsmc_cl013g_rvt_tt_1p2v_25c.db" 

#### Formality setup file ####
set synopsys_auto_setup true
set_svf "design.svf"

#### ref design files ####
read_verilog -container ref "/home/IC/Labs/Ass_Syn_2.0/rtl/mux_4_to_1.v"
read_verilog -container ref "/home/IC/Labs/Ass_Syn_2.0/rtl/parity_calc.v"
read_verilog -container ref "/home/IC/Labs/Ass_Syn_2.0/rtl/serializer.v"
read_verilog -container ref "/home/IC/Labs/Ass_Syn_2.0/rtl/UART_TX_FSM.v"
read_verilog -container ref "/home/IC/Labs/Ass_Syn_2.0/rtl/top_module.v"

read_db      -container ref "scmetro_tsmc_cl013g_rvt_tt_1p2v_25c.db"
set_reference_design top_module
set_top top_module

#### implementation design files ####
read_verilog -container ref "/home/IC/Labs/Ass_Syn_2.0/syn/UART_TX_top.v"
read_db      -container ref "scmetro_tsmc_cl013g_rvt_tt_1p2v_25c.db"
set_implementation_design top_module
set_top top_module

#### matching ####
match

#### verify ####
set successful [verify]
if {!$successful} {
diagnose
analyze_points -failing 
}

#### Reports ####
report_passing_points > "passing_points.rpt"
report_failing_points > "failing_points.rpt"
report_aborted_points > "aborted_points.rpt"
report_unverified_points > "unverified_points.rpt"


start_gui



