vlib work
vlog -timescale 1ns/1ns delay_counter.v
vsim delay_counter
log {/*}
add wave {/*}
# for the sake of simplicity and brevity for simulation divider is set to 8 instead of 8333333

force {clock} 0 0, 1 10 -repeat 20
force {reset_n} 0
run 20ns

force {clock} 0 0, 1 10 -repeat 20
force {reset_n} 1 
run 600ns

force {clock} 0 0, 1 10 -repeat 20
force {reset_n} 0
run 20ns
