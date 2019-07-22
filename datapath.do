vlib work
vlog -timescale 1ns/1ns lab7part3.v
vsim datapath_part3
log {/*}
add wave {/*}

force {clk} 0 0, 1 1 -r 2
force {reset_n} 1
force {x_in} 2#00001111
force {y_in} 2#0000111
force {color_in} 2#011

force {ld_x} 0 0, 1 10, 0 12
force {ld_y} 0 0, 1 20, 0 22

force {pixel} 0 0, 2#1110 28, 2#1111 30 -r 32

run 100ns

