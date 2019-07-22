vlib work
vlog -timescale 1ns/1ns lab7part3.v
vsim fsm_part3
log {/*}
add wave {/*}

force {clk} 0 0, 1 1 -r 2

force {reset_n} 1 0, 0 2, 1 4
force {x_in} 2#0001111
force {y_in} 2#000011
force {color_in} 2#110

force {frameCounter} 2#0000 0, 2#1110 200
			
run 400ns