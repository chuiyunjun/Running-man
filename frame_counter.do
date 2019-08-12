vlib work
vlog -timescale 1ns/1ns frame_counter.v
vsim frame_counter
log {/*}
add wave {/*}

force {clock} 0 0, 1 10 -repeat 20
force {reset_n} 0
force {resetn} 1
run 20ns

force {clock} 0 0, 1 10 -repeat 20
force {reset_n} 1
force {resetn} 1
run 400ns

force {clock} 0 0, 1 10 -repeat 20
force {reset_n} 1
force {resetn} 0
run 20ns
