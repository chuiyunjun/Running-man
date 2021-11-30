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

## 3. Running the game
Before you start. Please make sure you have:
- Intel® Quartus® Prime Software (https://www.intel.ca/content/www/ca/en/software/programmable/quartus-prime/download.html) _AND_ 
- DoC-SE1 Board, which can be purchased at https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=836 _AND_
- PS2 keyboard

The Intel® Quartus® Prime Software can be downloaded at http://fpgasoftware.intel.com/18.1/?edition=lite. Apple users do need to install a Windows or Ubuntu virtual machine before working with Intel® Quartus® Prime Software. 

Please follow the following steps for downloading the compiled project to the board:
- Connect your DE1-SoC board to your machine and open Quartus®.
- Click Tools -> Programmer. A window will pop-out.
- Click Hardware Setup. You should see the connected board in the window popped out.
- Double Click the DE1-SoC board, and press "OK".
- Delete everything in the file list.
- Press "Auto Detect", then select "5CSEMA" before pressing "OK".
- Double Click the "5CSEMA5" device, and import the output file from the output folder.
- Press "Start" to download the compiled code to the board.
- Connecting PS2 keyboard and screen with the board.
- Begin to play!
  - Inputs for gaming are mainly from the PS2 KEYBOARD
      - W key will allow the user to do a small jump to avoid short obstacles
      - C key will allow the user to duck under certain obstacles
      - S key will allow the user to go to a platform below
      - SPACE key will allow the user to jump to the above platform
  - Inputs from DE1-SOC board 
      - KEY[0] will allow to reset
      - SW[8:7] will allow to adjust the speed of obstacles' moving
          - 2'b00 ~ 2'b11 represents the speed from slow to fast
  - Obstacles will be randomly generated through a LFSR
  - Score will be calculated per second alive, shown on the HEX of DE1-SOC

**Developed by:** Chi Zhang, Ting Jui Peng
