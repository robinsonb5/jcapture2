# JCapture 2
A JTAG debugging probe in Verilog, by Alastair M. Robinson

This is an updated and improved version of my previous JTAG_Capture project which was written in VHDL. The primary differences are:
* Written in plain Verilog to make it easier to use with yosys and other toolchains with limited VHDL / SystemVerilog support.
* Samples the JTAG clock from the system clock (which needs to be significantly faster than the JTAG clock, for obvious reasons). This was done because running significant amounts of logic from the JTAG clock appears to become unreliable on both Lattice ECP5 and Gowin GW2AR devices once the FPGA becomes moderately full.
* Support for user commands, to semi-standardise triggering events in the design from the host computer.
* A simple (and optional) run-length encoding scheme allows more samples to be captured when signals remain constant over multiple cycles.
