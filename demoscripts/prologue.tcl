# Setup common to the three demo scripts

init
scan_chain

# The name and bit width of each field in the captured data
# starting at the least-significant bit

set capture_fields {
	{ count_lo 16 }
	{ count_hi 15 }
}


# Enumerate user IR codes, starting at 0

set ::jcapture::usercodes {
	reset led
}


puts "Setting TAP, capture fields and length"

set loc [file dirname [file normalize [info script]]]
source ${loc}/../tcl/jcapture.tcl
::jcapture::setup target.tap $capture_fields 0x35ac
