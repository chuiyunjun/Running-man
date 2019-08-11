

module RnningMan
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
		KEY,
        SW,
		  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,  						//	VGA Blue[9:0]
		PS2_DAT,PS2_CLK,GPIO_0, GPIO_1
	);
	
	input    PS2_DAT;
   input    PS2_CLK;
   //  GPIO Connections
   inout  [35:0]  GPIO_0, GPIO_1;
	assign  GPIO_0    =  36'hzzzzzzzzz;
	assign  GPIO_1    =  36'hzzzzzzzzz;
	wire [4:0] keys;
	ps2test pt0(.clk(CLOCK_50),
					.resetn(resetn),
					.PS2_DAT(PS2_DAT),
					.PS2_CLK(PS2_CLK),
					.GPIO_0(GPIO_0), 
					.GPIO_1(GPIO_1),
					.BoardKey(keys));

	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;
	output  [6:0]   HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	wire resetn;
	
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;


	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	
	

	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.
    wire drawing_floors_finish,
			draw_tree,
			draw_man_finish,
			draw_tree_finish,
			erase_finish,
			drawing_floors,
			draw_man,
			erase,
			ld_x,
			ld_y,
			ld_man_style,
			ld_shape,
			gameover,
			reset_frame_counter,
			normal1crouch0,
			update; 
			
		fsm fsm0(.clk(CLOCK_50),
					.reset_n(resetn),
					.draw_floors_finish(drawing_floors_finish),
					.erase_finish(erase_finish),
					.frameCounter(frameCounter),
				  .top_shape_f(top_shape_f),
				  .mid_shape_f(mid_shape_f),
				  .bottom_shape_f(bottom_shape_f),
					.gameover(gameover),
				  .y_w(y_w),
				  .x_w(x_w),
				  .crouch(keys[2]),
				  .draw_gameover_finish(gameover_finished),
					.drawing_floors(drawing_floors),
					.draw_man_finish(draw_man_finish),
					.draw_tree_finish(draw_tree_finish),
					.erase(erase),
					.ld_x(ld_x),
					.ld_y(ld_y),
					.ld_man_style(ld_man_style),
					.reset_frame_counter(reset_frame_counter),
					.update(update),
					.draw_man(draw_man),
					.draw_tree(draw_tree),
					.writeEn(writeEn)
					);
					
					

		datapath d0(.clk(CLOCK_50),
					.reset_n(resetn),
					.drawing_floors(drawing_floors),
					.draw_man(draw_man),
					.gameover(gameover),
					.draw_tree(draw_tree),
					.erase(erase),
					.x_in(x_w),
					.y_in(y_w),
					.update(update),
					.draw_floors_finish(drawing_floors_finish),
					.draw_man_finish(draw_man_finish),
					.erase_finish(erase_finish),
					.draw_tree_finish(draw_tree_finish),
               .draw_gameover_finish(gameover_finished),
					.top(top_shape),
					.mid(mid_shape),
					.bottom(bottom_shape),
					.color(colour),
					.x(x),
					.y(y),
					.ld_x(ld_x),
					.ld_y(ld_y),
					.ld_man_style(ld_man_style),
					.ld_shape(ld_shape),
					.man_style(!keys[2]),
				  .top_shape(top_shape_f),
				  .mid_shape(mid_shape_f),
				  .bottom_shape(bottom_shape_f)
				);
	  wire gameover_finished;
        wire [1:0] top_shape_f, mid_shape_f, bottom_shape_f;
      wire newClock;
		wire [3:0] frameCounter;
		delay_counter dc0(.reset_n(resetn), .clock(CLOCK_50), .new_clock(newClock));
		frame_counter fc0(.clock(newClock), .reset_n(reset_frame_counter), .resetn(resetn), .counter(frameCounter));

		/*
		movement m0(.clk(CLOCK_50), .operation(move), .reset(resetn), .update(update), .yout(y_in));
		wire [2:0] move; 

	   input_decoder INPUT(
		.clk(CLOCK_50),
		.reset(resetn),
		.inputkeys(~KEY[3:1]),
		.movement(move)
	);
	*/
		wire [6:0] y_w;
		wire [7:0] x_w;
	   yBox ybox0(.clk(CLOCK_50), .resetn(resetn), .update(update), .keys({!keys[1], !keys[0], !keys[3]}), .y(y_w), .man_style(!keys[2]));

	   wire [1:0] top_shape, mid_shape, bottom_shape;
	   wire [11:0] count;
	   rand r0(.clk(CLOCK_50), .reset_n(resetn), .count(count));
	   shape s0(.reset_n(resetn), .update(update), .count(count), .top_shape(top_shape), .mid_shape(mid_shape), .bottom_shape(bottom_shape));
	   x_counter xc0(.speed(SW[8:7]), .resetn(resetn), .update(update), .x(x_w), .ld_shape(ld_shape));
		scorecounter s1(CLOCK_50, resetn, gameover, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
		
		
endmodule



module delay_counter(clock, reset_n, new_clock);
	input clock, reset_n;
	wire [19:0] divider;
	reg [19:0] q;
	output new_clock;
	
	assign divider = 20'd833333;
	//assign divider = 25'h2;
	always @(posedge clock, negedge reset_n)
	begin
		if(reset_n == 1'b0)
			q <= divider - 1'b1;
		else
		begin
			if(q == 20'h0)
				q <= divider - 1'b1;
			else
				q <= q - 1'b1;
		end
	end
	assign new_clock = (q == 20'd0) ? 1'b1 : 1'b0;
	
endmodule


module frame_counter(
	input clock, reset_n, resetn,
	output reg [3:0] counter);

	always @(posedge clock, negedge reset_n, negedge resetn) begin
		if(reset_n == 1'b0 || resetn == 1'b0)
			counter <= 1'b0;
		else
			counter <= counter + 1'b1;
	end
endmodule
