vlib work
vlog -timescale 1ns/1ns randomshapes.v
vsim shape
log {/*}
add wave {/*}

force {count} 010010101001
force {update} 0 0, 1 10 -repeat 20
force {reset_n} 0
run 20ns

force {count} 010010101001
force {update} 0 0, 1 10 -repeat 20
force {reset_n} 1
run 20ns

force {count} 010000100001
force {update} 0 0, 1 10 -repeat 20
force {reset_n} 1
run 20ns

force {count} 010110101011
force {update} 0 0, 1 10 -repeat 20 
force {reset_n} 1
run 20ns
