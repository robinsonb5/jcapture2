JCAPTURE_DIR = ../rtl/
FPGA_FAMILY = ecp5
include $(JCAPTURE_DIR)/jcapture.mk
VERILOG_SOURCES = $(JCAPTURE_VERILOG_SOURCES) top.v
TEST_SOURCES := $(wildcard tb/*.v) $(wildcard tb/*.sv)
OUTPUT := jtag_capture
PACKAGE := CABGA256
FPGA_SIZE ?= 25k

all: help

%.json: $(VERILOG_SOURCES)
	@echo ""
	@echo "Running synthesis (yosys)"
	@rm -f $(OUTPUT).bit $(OUTPUT).config $(OUTPUT).json
	@yosys >synth.log -p 'read_verilog -sv $(VERILOG_SOURCES); synth_ecp5 -top top -json $@'

%.config: %.json icesugarpro.lpf
	@echo ""
	@echo "Running place-and-route (nextpnr)"
	@nextpnr-ecp5 2>pnr.log --$(FPGA_SIZE) --package $(PACKAGE) --lpf icesugarpro.lpf --json $< --textcfg $@

%.bit: %.config
	@echo ""
	@echo "Generating bitstream (ecppack)"
	@ecppack --compress $< $@

build: $(OUTPUT).bit

config: build
# The IceSugarPro's internal cmsis-dap programmer isn't recognised by openFPGALoader
# but works as long you specify the correct USB vendor and product ID.
# (OpenOCD can recognise it from the string "CMSIS-DAP" in the USB product string)
	openFPGALoader -c cmsisdap --vid 0x1d50 --pid 0x602b $(OUTPUT).bit
	@echo ""
	@echo "To run a JTAG test, either type \"make run\" or"
	@echo "run the demo.tcl script with OpenOCD."
	@echo "See also the capvcd.tcl and capcsv.tcl scripts."
	
run:
	openocd -f icesugarpro.cfg -f ../demoscripts/demo.tcl
	@echo ""
	@echo "To repeat the JTAG test, run the demo.tcl script."
	@echo "See also the capvcd.tcl and capcsv.tcl scripts."

lint:
	verilator --lint-only -Wall -Wno-DECLFILENAME -Wno-WIDTHEXPAND $(VERILOG_SOURCES)

help:
	@echo "Usage: make [option]"
	@echo "Options:"
	@echo "- build: builds the bitstream"
	@echo "- clean: delete generated and temporary files"
	@echo "- config: install to chip's temp memory (bitstream lost on power loss)"
	@echo "- run: execute a tcl script to communicate with the running design"

clean:
	rm -f $(OUTPUT).bit $(OUTPUT).config $(OUTPUT).json *.log

.PHONY: build clean install
