vlib work
vlog -timescale 1ns/1ns fsm.v
vsim fsm
log {/*}
add wave {/*}

force {clk} 0 0, 1 1 -r 2
force {reset_n} 1 0, 0 2, 1 4

force {draw_floors_finish} 0 0, 1 50, 0 52
force {erase_finish} 0 0, 1 400, 0 402
force {draw_man_finish} 0 0, 1 60, 0 62
force {draw_tree_finish} 0 0, 1 70, 0 72
force {draw_gameover_finish} 0 0, 1 500, 0 502
force {frameCounter} 2#0000 0, 2#1110 190 -r 200
force {top_shape_f} 2#01
force {mid_shape_f} 2#00
force {bottom_shape_f} 2#10
force {y_w} 2#0011111
force {x_w} 2#00011111
force {crouch} 0

			
run 800ns