#!./oocd.sh
#
# JTAG Capture demo script
#

# Setup code in common between the three demo scripts
set loc [file dirname [file normalize [info script]]]
source ${loc}/prologue.tcl

puts ""
puts "Turning on LED"
::jcapture::usercmd led 1

puts "Setting capture parameters..."

# We only care about bit 8 of count_lo - we want it to be a rising edge
::jcapture::settrigger count_lo posedge mask 0x100

# We want an exact match on bits 7:0 of count_hi, with 0xaa
::jcapture::settrigger count_hi 0xaa mask 0xff

# No lead-in
::jcapture::setleadin 0

# Send capture parameters and start capturing...
::jcapture::capture

puts "Waiting for the FIFO"
::jcapture::wait_fifofull

puts "Collecting the FIFO contents"
puts "Capture should start when bit 8 rises."
::jcapture::dump_fifo

puts ""
puts "Repeating the capture with a 1/4 lead-in."
::jcapture::setleadin 3


# Change LEDs
::jcapture::usercmd led 2

# Change the trigger to the falling edge of bit 10
::jcapture::settrigger count_lo negedge mask 0x400
::jcapture::settrigger count_hi mask 0

::jcapture::capture

puts "Waiting for the FIFO to fill"
::jcapture::wait_fifofull

# Change LEDs
::jcapture::usercmd led 4

puts "Collecting the FIFO contents"
puts "Capture should start when bit 10 rises,"
puts "after a lead-in of 1/4 of the FIFO's depth."

::jcapture::dump_fifo

# Turn off the LEDs
puts "Turning off LEDs"
::jcapture::usercmd led 0

puts ""
puts "Taking a few one-shot samples"
::jcapture::flush_fifo
::jcapture::command sample
::jcapture::command sample
::jcapture::command sample
::jcapture::dump_fifo

puts ""
puts "Resetting the design"
::jcapture::usercmd reset 1
::jcapture::usercmd reset 0

puts "Setting trigger to light LED when count_hi = 0x1000"
::jcapture::settrigger count_hi 0x1000 mask 0xffff
::jcapture::notify_trigger
::jcapture::wait_busy

puts "Done."
exit


