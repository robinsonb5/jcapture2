JCAPTURE_DIR = ../rtl/
include $(JCAPTURE_DIR)/jcapture.mk
VERILOG_SOURCES = $(JCAPTURE_VERILOG_SOURCES) top.v
TEST_SOURCES := $(wildcard tb/*.v) $(wildcard tb/*.sv)
GOWIN_EDA=$(GOWINHOME)/IDE/bin/gw_sh
OUTPUT=impl/pnr/jtag_capture.fs

all: help

$(GOWIN_EDA):
	@echo ""
	@echo "Please install Gowin EDA, then set GOWINHOME to the"
	@echo "directory where it was unpacked."
	@exit 1

$(OUTPUT): $(GOWIN_EDA)
	$(GOWIN_EDA) build.tcl

build: $(OUTPUT)

config: $(OUTPUT)
	openFPGALoader -b tangnano20k $(OUTPUT)
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
	rm -rf impl

.PHONY: build clean install
