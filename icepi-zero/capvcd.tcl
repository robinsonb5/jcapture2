#! ./oocd.sh
#
# IceSugarPro demo JTAG script
#

source "prologue.tcl"
init
scan_chain

set capture_fields {
	{ count_lo 16 }
	{ count_hi 15 }
}

# Put design in reset
::jcapture::usercmd reset 1

# Start the capture when count_hi reaches 0x0001
::jcapture::settrigger count_hi 0x0001

# Set a leadin of 1/4 of the FIFO's depth, so the trigger event
# will be 25% of the way into the recorded data.
::jcapture::setleadin 3

# Start recording
::jcapture::capture

# Release reset and wait for the FIFO to fill.
::jcapture::usercmd reset 0
::jcapture::wait_fifofull

puts "Recording to cap.vcd"

# Create a .vcd file and save the FIFO's contents to it
set chan [::jcapture::create_vcd cap.vcd]
::jcapture::fifo_to_vcd $chan

exit
