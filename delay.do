vlib work
vlog -timescale 1ns/1ns comb.v
vsim delay_counter
log {/*}
add wave {/*}

force {clock} 0 0, 1 1 -r 2
force {reset_n} 1 0, 0 2, 1 4

run 40000000ns