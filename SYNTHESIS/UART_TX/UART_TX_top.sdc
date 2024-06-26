###################################################################

# Created by write_sdc on Fri Aug 25 03:00:42 2023

###################################################################
set sdc_version 2.0

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA
set_operating_conditions -max scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -max_library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -min scmetro_tsmc_cl013g_rvt_ff_1p32v_m40c -min_library scmetro_tsmc_cl013g_rvt_ff_1p32v_m40c
set_wire_load_model -name tsmc13_wl30 -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c
set_driving_cell -lib_cell BUFX2M -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -pin Y [get_ports {p_data[7]}]
set_driving_cell -lib_cell BUFX2M -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -pin Y [get_ports {p_data[6]}]
set_driving_cell -lib_cell BUFX2M -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -pin Y [get_ports {p_data[5]}]
set_driving_cell -lib_cell BUFX2M -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -pin Y [get_ports {p_data[4]}]
set_driving_cell -lib_cell BUFX2M -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -pin Y [get_ports {p_data[3]}]
set_driving_cell -lib_cell BUFX2M -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -pin Y [get_ports {p_data[2]}]
set_driving_cell -lib_cell BUFX2M -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -pin Y [get_ports {p_data[1]}]
set_driving_cell -lib_cell BUFX2M -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -pin Y [get_ports {p_data[0]}]
set_driving_cell -lib_cell BUFX2M -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -pin Y [get_ports data_valid]
set_driving_cell -lib_cell BUFX2M -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -pin Y [get_ports par_en]
set_driving_cell -lib_cell BUFX2M -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -pin Y [get_ports par_typ]
set_load -pin_load 0.5 [get_ports tx_out]
set_load -pin_load 0.5 [get_ports busy]
create_clock [get_ports clk]  -name CLK  -period 100  -waveform {0 50}
set_clock_latency 0  [get_clocks CLK]
set_clock_uncertainty -setup 0.25  [get_clocks CLK]
set_clock_uncertainty -hold 0.05  [get_clocks CLK]
set_clock_transition -max -rise 0.1 [get_clocks CLK]
set_clock_transition -min -rise 0.1 [get_clocks CLK]
set_clock_transition -max -fall 0.1 [get_clocks CLK]
set_clock_transition -min -fall 0.1 [get_clocks CLK]
group_path -name INOUT  -from [list [get_ports {p_data[7]}] [get_ports {p_data[6]}] [get_ports {p_data[5]}] [get_ports {p_data[4]}] [get_ports {p_data[3]}] [get_ports {p_data[2]}] [get_ports {p_data[1]}] [get_ports {p_data[0]}] [get_ports data_valid] [get_ports par_en] [get_ports par_typ] [get_ports clk] [get_ports rst]]  -to [list [get_ports tx_out] [get_ports busy]]
group_path -name INREG  -from [list [get_ports {p_data[7]}] [get_ports {p_data[6]}] [get_ports {p_data[5]}] [get_ports {p_data[4]}] [get_ports {p_data[3]}] [get_ports {p_data[2]}] [get_ports {p_data[1]}] [get_ports {p_data[0]}] [get_ports data_valid] [get_ports par_en] [get_ports par_typ] [get_ports clk] [get_ports rst]]
group_path -name REGOUT  -to [list [get_ports tx_out] [get_ports busy]]
set_input_delay -clock CLK  30  [get_ports {p_data[7]}]
set_input_delay -clock CLK  30  [get_ports {p_data[6]}]
set_input_delay -clock CLK  30  [get_ports {p_data[5]}]
set_input_delay -clock CLK  30  [get_ports {p_data[4]}]
set_input_delay -clock CLK  30  [get_ports {p_data[3]}]
set_input_delay -clock CLK  30  [get_ports {p_data[2]}]
set_input_delay -clock CLK  30  [get_ports {p_data[1]}]
set_input_delay -clock CLK  30  [get_ports {p_data[0]}]
set_input_delay -clock CLK  30  [get_ports data_valid]
set_input_delay -clock CLK  30  [get_ports par_en]
set_input_delay -clock CLK  30  [get_ports par_typ]
set_output_delay -clock CLK  30  [get_ports tx_out]
set_output_delay -clock CLK  30  [get_ports busy]
