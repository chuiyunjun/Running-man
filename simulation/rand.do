vlib work
vlog -timescale 1ns/1ns randomshapes.v
vsim rand
log {/*}
add wave {/*}

force {clk} 0 0, 1 10 -repeat 20
force {reset_n} 0
run 20ns

force {clk} 0 0, 1 10 -repeat 20
force {reset_n} 1
run 200ns

force {clk} 0 0, 1 10 -repeat 20
force {reset_n} 0
run 20ns

