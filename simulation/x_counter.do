vlib work
vlog -timescale 1ns/1ns xCounter.v
vsim x_counter
log {/*}
add wave {/*}

force {speed} 00
force {resetn} 0
force {update} 0
run 20ns

force {speed} 00
force {resetn} 1
force {update} 0 0, 1 10 -repeat 20
run 60ns

force {speed} 01
force {resetn} 1
force {update} 0 0, 1 10 -repeat 20
run 60ns

force {speed} 10
force {resetn} 1
force {update} 0 0, 1 10 -repeat 20
run 60ns

force {speed} 11
force {resetn} 1
force {update} 0 0, 1 10 -repeat 20
run 60ns

force {speed} 11
force {resetn} 0
force {update} 0
run 20ns
