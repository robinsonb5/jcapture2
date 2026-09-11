JCAPTURE_DIR = ../rtl/
FPGA_FAMILY = gw2a
include $(JCAPTURE_DIR)/jcapture.mk
VERILOG_SOURCES = $(JCAPTURE_VERILOG_SOURCES) top.v
TEST_SOURCES := $(wildcard tb/*.v) $(wildcard tb/*.sv)
PACKAGE := CABGA256
FPGA_SIZE ?= 25k
OUTPUT = jtag_capture

all: help

%.json: $(VERILOG_SOURCES)
	rm -f $(OUTPUT).bit $(OUTPUT).config synth.json
	@echo "Running synthesis (yosys)"
	yosys >synth.log -p 'read_verilog -sv $(VERILOG_SOURCES); synth_gowin -top top -family gw2a -json $@'

$(OUTPUT)_pnr.json: $(OUTPUT)_synth.json $(OUTPUT).cst
	@echo ""
	@echo "Running place-and-route (nextpnr)"
	nextpnr-himbaechel 2>pnr.log --device GW2AR-LV18QN88C8/I7 --json $(OUTPUT)_synth.json --write $(OUTPUT)_pnr.json --vopt family=GW2A-18C --vopt cst=jtag_capture.cst

$(OUTPUT).fs: $(OUTPUT)_pnr.json
	@echo ""
	@echo "Generating bitstream (gowin_pack)"
	gowin_pack -c -d GW2A-18C -o $(OUTPUT).fs $(OUTPUT)_pnr.json

build: $(OUTPUT).fs

config: build
	openFPGALoader $(OUTPUT).fs
	@echo ""
	@echo "To run a JTAG test, either type \"make run\" or"
	@echo "run the demo.tcl script with OpenOCD."
	@echo "See also the capvcd.tcl and capcsv.tcl scripts."
	
run:
	openocd -f tangnano20k.cfg -f ../demoscripts/demo.tcl
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
	rm -f $(OUTPUT).fs $(OUTPUT).config $(OUTPUT)_synth.json $(OUTPUT)_pnr.json *.log

.PHONY: build clean install
