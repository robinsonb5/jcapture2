
create_clock -name clk -period 37.037 -waveform {0 18.518} [get_ports {clk}]
create_clock -name jtck -period 100 [get_pins {top/capture/jtag_inst/jtag_inst_0/jtagshim/tck_pad_i}]
