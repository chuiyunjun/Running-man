vlib work
vlog -timescale 1ns/1ns scorecounter.v
vsim scorecounter
log {/*}
add wave {/*}
# for brevity and simulation purposes rate divider is set to divide by 4 instead of 49,999,999
force {clk} 0 0, 1 1 -repeat 2
force {reset} 0
force {gameover} 0
run 2ns

force {clk} 0 0, 1 1 -repeat 2
force {reset} 1
force {gameover} 0
run 50ns

force {clk} 0 0, 1 1 -repeat 2
force {reset} 1
force {gameover} 1
run 50ns

force {clk} 0 0, 1 1 -repeat 2
force {reset} 0
force {gameover} 1
run 2ns
