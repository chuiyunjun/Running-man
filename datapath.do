vlib work
vlog -timescale 1ns/1ns datapath.v
vsim datapath
log {/*}
add wave {/*}

force {clk} 0 0, 1 1 -r 2
force {reset_n} 1 0, 0 2, 1 4
force {x_in} 8#00011111
force {y_in} 7#0011111
force {erase} 0 0, 1 70, 0 72
force {drawing_floors} 0 0, 1 20, 0 22
force {draw_man} 0 0, 1 40, 0 42
force {man_style} 1
force {draw_tree} 0 0, 1 60, 0 62
force {gameover} 0 0, 1 100, 0 102
force {ld_x} 0 0, 1 30, 0 32
force {ld_y} 0 0, 1 30, 0 32
force {ld_man_style} 0 0, 1 30, 0 32
force {ld_shape} 0 0, 1 30, 0 32
force {top} 2#00
force {mid} 2#01
force {bottom} 2#11
force {update} 0 0, 1 80, 0 82

			
run 200ns