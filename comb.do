vlib work
vlog -timescale 1ns/1ns comb.v
vsim comb
log {/*}
add wave {/*}

force {CLOCK_50} 0 0, 1 1 -r 2
force {resetn} 1 0, 0 2, 1 4
force {x_in} 2#00011111
force {KEY[1]} 1 
force {KEY[2]} 1
force {KEY[3]} 1
run 400000000 ns

