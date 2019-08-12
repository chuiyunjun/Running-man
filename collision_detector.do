vlib work
vlog -timescale 1ns/1ns fsm.v
vsim collision_detector
log {/*}
add wave {/*}

force {curr_y} 1101100
force {curr_x} 01101110
force {crouch} 0
force {lane1} 11
force {lane2} 11
force {lane3} 10
run 20ns

force {curr_y} 1101100
force {curr_x} 00011001
force {crouch} 0
force {lane1} 11
force {lane2} 11
force {lane3} 10
run 20ns

force {curr_y} 1101100
force {curr_x} 00011001
force {crouch} 1
force {lane1} 11
force {lane2} 11
force {lane3} 10
run 20ns


force {curr_y} 1101100
force {curr_x} 00011001
force {crouch} 0
force {lane1} 11
force {lane2} 11
force {lane3} 00
run 20ns

force {curr_y} 1010000
force {curr_x} 00011001
force {crouch} 0
force {lane1} 11
force {lane2} 11
force {lane3} 00
run 20ns

force {curr_y} 1010000
force {curr_x} 00011001
force {crouch} 0
force {lane1} 11
force {lane2} 11
force {lane3} 01
run 20ns
