vlib work
vlog -timescale 1ns/1ns comb.v
vsim comb
log {/*}
add wave {/*}

force {CLOCK_50} 0 0, 1 1 -r 2
force {resetn} 1 0, 0 2, 1 4
force {x_in} 2#00011111
force {y_in} 2#1101100
run 40000000 ns

