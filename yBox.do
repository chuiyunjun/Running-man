vlib work
vlog -timescale 1ns/1ns yBox.v
vsim yBox
log {/*}
add wave {/*}

force {clk} 0 0, 1 1 -r 2
force {man_style} 1
force {resetn} 1 0, 0 2, 1 4
force {keys} 2#111 0, 2#101 60, 2#110 700, 2#111 702, 2#011 1300, 2#111 1302, 2#101 1450, 2#111 1452
force {update} 0 0, 1 2, 0 4 -r 40
run 3000ns