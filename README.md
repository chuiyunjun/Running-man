# Running-man

CSC258 project Running Man
=============================

Running Man is a game that consists of 3 platforms which the user will be able to switch between while avoiding obstacles using a PS2 keyboard.

Top Level Module: **RunningMan_top.v**

Running Man is written in verilog and tested with a DE1-SOC board

## 1. Modules We Created
- datapath.v: Output unit to pass values into the VGA_ADAPTER and FSM
- delay_counter.v: Used to change the 50MHZ clk to the 60HZ required for the monitor passed to frame_counter
- frame_counter.v: Counts the frames to be passed into FSM for processing
- fsm.v: Control unit to understand the inputs passed in from other modules controls datapath, scorecounter.
- randomshapes.v: Generates the random obstacles the User will face passed to fsm
- scorecounter.v: Counts the score 1 point per second until the player loses recieves stop from fsm
- xCounter.v: Counts the position of the obstacles coming towards to the user passed to fsm and datapath
- yBox.v: Calculates the players Y position after input movements passed to fsm and datapath

## 2. Resources Used
- [vga adapter](http://www.eecg.utoronto.ca/~jayar/ece241_08F/vga/): Was used to render the images displayed on the monitor
  - vga_adapter.v
  - vga_address_translator.v
  - vga_controller.v
  - vga_pll.v
- [ps2 keyboard](https://johnloomis.org/digitallab/ps2lab1/ps2lab1.html#top): Used to connect a PS2 keyboard to work with the DE1-SOC board
  - ps2test.v: Top level module in ps2test was modified to work with our code

## 3. Features
- Inputs for gaming are mainly from the PS2 KEYBOARD
- W key will allow the user to do a small jump to avoid short obstacles
- C key will allow the user to duck under certain obstacles
- S key will allow the user to go to a platform below
- SPACE key will allow the user to jump to the above platform
- Obstacles will be randomly generated through a LFSR
- Score will be calculated per second alive

## 4. Requirements
- DE1-SOC board (tested) and a PS2 Keyboard
- [Quartus Prime Lite v18.1](http://fpgasoftware.intel.com/?edition=lite) (tested)


**Developed by:** Chi Zhang, Ting Jui Peng
