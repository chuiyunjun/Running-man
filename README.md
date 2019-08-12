# Running-man

CSC258 project Running Man
=============================

Running Man is a game that consists of 3 platforms which the user will be able to switch between while avoiding obstacles. 
Requires a PS2 keyboard

Top Level Module: **RunningMan_top.v**

Running Man is written in verilog and tested with a DE1-SOC board

## 1. Modules We Created
- datapath.v:
- delay_counter.v:
- frame_counter.v:
- fsm.v:
- randomshapes.v:
- scorecounter.v:
- xCounter.v:
- yBox.v:

## 2. Resources Used
- [vga adapter](http://www.eecg.utoronto.ca/~jayar/ece241_08F/vga/)
  - vga_adapter.v
  - vga_address_translator.v
  - vga_controller.v
  - vga_pll.v
  - Was used to render the images displayed on the monitor
- [ps2test.v](https://johnloomis.org/digitallab/ps2lab1/ps2lab1.html#top):
  - Top level module in ps2test was modified to work with our code
  - Used to connect a PS2 keyboard to work with the DE1-SOC board

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
