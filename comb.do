vlib work
vlog -timescale 1ns/1ns lab7part3.v
vsim combination
log {/*}
add wave {/*}

force {CLOCK_50} 0 0, 1 1 -r 2
force {resetn} 1 0, 0 2, 1 4
force {color_in} 2#110

run 40000000 ns

