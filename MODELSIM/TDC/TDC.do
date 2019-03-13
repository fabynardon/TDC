quit -sim

# Create work library
vlib work

# Ensure xilinx libraries are mapped correctly
# Your xilinx install may be different, so double check this line
vmap simprim {C:\Xilinx\14.7\ISE_DS\ISE\vhdl\mti_pe\10.4a\nt64\simprim}

# Compile the file
vcom {C:\Users\root\Desktop\TDC\ISE\TDC\netgen\par\test_timesim.vhd}

# Start the simulation and provide the timing information
# sdftyp uses "typical" delays
# can also use sdfmax (max delays) or sdfmin (min delays)

vsim -sdftyp {C:\Users\root\Desktop\TDC\ISE\TDC\netgen\par\test_timesim.sdf}  work.test
#vsim work.test

# Open waveform window
view wave

# change radix to hex
radix hex

# Add signals to waveform window

add wave sim:/test/clock
add wave  sim:/test/stop
add wave  sim:/test/unreg
add wave sim:/test/reg
add wave sim:/test/salida
add wave sim:/test/reset

# Force clock
#force sim:/test/clock 0 5ns, 1 {10000 ps} -r 10ns
force sim:/test/clock 0 0ns
force sim:/test/clock 1 30ns
force sim:/test/stop 0 0
force sim:/test/stop 1 112663
force sim:/test/reset 0 0
force sim:/test/reset 1 107000
force sim:/test/reset 0 107500

run 150 ns