# Running-man

CSC258 project Running Man
=============================

Running Man is a game that consists of 3 platforms which the user will be able to switch between while avoiding obstacles using a PS2 keyboard.

Top Level Module: **RunningMan_top.v**

Running Man is written in verilog and tested with a DE1-SOC board and a PS2 Keyboard

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
- Inputs from DE1-SOC board 
    - KEY[0] will allow to reset
    - SW[8:7] will allow to adjust the speed of obstacles' moving
        - 2'b00 ~ 2'b11 represents the speed from slow to fast
- Obstacles will be randomly generated through a LFSR
- Score will be calculated per second alive, shown on the HEX of DE1-SOC

## 4. Requirements
- DE1-SoC board (tested) and a PS2 Keyboard
- [Quartus Prime Lite v18.1](http://fpgasoftware.intel.com/?edition=lite) (tested)


## 5. Tips to begin
 1. Setup hardware: Connect DE1-SoC Board, computer, screen and PS2 Keyboard.
 2. Open **Quartus Prime** (version 18) and go to **File** > **New**... and select **New Quartus Prime Project**. 
 3. Click Next and under Directory, Name, Top-Level Entity select your working directory(the folder containing .v files of the project) and type
    the name of your project ('RunningMan' is suggested here, as it is the top-level module name). The top-level design will automatically fill
    out to be the same name as your project.
 4. Click **Next until** you reach **Add Files** and select all .v files. Then click **Next**.
 5. Click **Next** until your each **Family & Device Settings** and select the chip **5CSEMA5F31C6** under Available Devices and then click           **Finish**. This device belongs to the Cyclone V FPGA family. If you notice that the device name shown under Hierarchy in the Project            Navigator in the left side of your Quartus window is incorrect, right click on the device name and select **Device..** to change it.
 6. Obtain a copy of the **DE1_SoC.qsf** file available and place it in your design directory. This file associates signal names to pins on the  chip. If you use these exact signal names for the inputs and outputs in your design, the tool will connect those signals to the appropriate pins. You can examine the file in an editor to see the names and pin numbers. Note that pin numbers will not seem very meaningful to you. These pin numbers are provided by the manufacturer of the board in documentation. The DE1 SoC.qsf file was created by consulting this documentation. 
 7. Click on **Assignments > Import Assignments...** and import the **DE1_SoC.qsf** file. 
 8. Start Compiling by clicking **Processing > Start Compilation** or pressing shortcut **Ctrl + L**. (Compilation usually takes minutes.)
 9. When compilation is done, click **Tools > Programmer** and a window will appear. 
 10. Go to **Hardware Setup** and ensure Currently Selected Hardware is DE1-SoC[USB-x] and close the window. 
 11. Click **Auto Detect** and select **5CSEMA5**. Then click **OK**.
 12. Double click <none> for device 5CSEMA5 and load SOF file (usually under folder "output files") and device will change to 5CSEMA5F31.
 13. Ensure Program/Configure for device "5CSEMA5F31" is checked and click **Start**. 
 14. Press KEY[0] on DE1-SoC board (reset button) to start the game.


**Developed by:** Chi Zhang, Ting Jui Peng
