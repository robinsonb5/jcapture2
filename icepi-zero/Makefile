JCAPTURE_DIR = ../rtl/
include $(JCAPTURE_DIR)/jcapture.mk
VERILOG_SOURCES = $(JCAPTURE_VERILOG_SOURCES) top.v
TEST_SOURCES := $(wildcard tb/*.v) $(wildcard tb/*.sv)
OUTPUT := bitstream
PACKAGE := CABGA256
FPGA_SIZE ?= 25k

all: debug

%.json: $(VERILOG_SOURCES)
	rm -f $(OUTPUT).bit $(OUTPUT).config $(OUTPUT).json
	yosys -p 'read_verilog -sv $(VERILOG_SOURCES); synth_ecp5 -top top -json $@'

%.config: %.json icepi-zero.lpf
	nextpnr-ecp5 --$(FPGA_SIZE) --package $(PACKAGE) --lpf icepi-zero.lpf --json $< --textcfg $@

%.bit: %.config
	ecppack --compress $< $@

build: $(OUTPUT).bit

debug: build
	openFPGALoader -b icepi-zero $(OUTPUT).bit
	@echo ""
	@echo "To run a JTAG test, either type \"make run\" or"
	@echo "run the demo.tcl script with OpenOCD."
	@echo "See also the capvcd.tcl and capcsv.tcl scripts."
	
run:
	openocd -f icepi-zero.cfg -f demo.tcl
	@echo ""
	@echo "To repeat the JTAG test, run the demo.tcl script."
	@echo "See also the capvcd.tcl and capcsv.tcl scripts."

lint:
	verilator --lint-only -Wall -Wno-DECLFILENAME -Wno-WIDTHEXPAND $(VERILOG_SOURCES)

help:
	@echo "Usage: make [option]"
	@echo "Options:"
	@echo "- debug: install to chip's temp memory (bitstream lost on power loss)"
	@echo "- build: builds the bitstream"
	@echo "- clean: delete all temporary files"
	@echo "- run: execute a tcl script to communicate with the running design"

clean:
	rm -f $(OUTPUT).bit $(OUTPUT).config $(OUTPUT).json

.PHONY: build clean install
