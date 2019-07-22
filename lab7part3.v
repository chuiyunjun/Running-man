

module lab7part3
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
        SW,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;

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
	wire [2:0] move; // movement determined by user inputs
	input_decoder INPUT(
		.clk(CLOCK_50),
		.reset(resetn),
		.inputkeys(~KEY[3:1]),
		.movement(move)
	);

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
			erase_finish,
			drawing_floors,
			erase,
			ld_x,
			ld_y,
			ld_man_style,
			reset_frame_counter,
			normal1crouch0,
			x_in
			y_in;
			
			
		fsm fsm0(.clk(CLOCK_50),
					.reset_n(resetn),
					.drawing_floors_finish(drawing_floors_finish),
					.erase_finish(erase_finish),
					.frameCounter(frameCounter),
					.drawing_floors(drawing_floors),
					.erase(erase),
					.ld_x(ld_x),
					.ld_y(ld_y),
					.ld_man_style(ld_man_style),
					.reset_frame_counter(reset_frame_counter),
					.writeEn(writeEn)
					);
					
		datapath d0(.clk(CLOCK_50),
					.reset_n(resetn),
					.drawing_floors(drawing_floors),
					.draw_man(draw_man),
					.erase(erase),
					.x_in(x_in),
					.y_in(y_in),
					.normal1crouch0(normal1crouch0),
					.drawing_floors_finish(drawing_floors_finish),
					.draw_man_finish(draw_man_finish),
					.erase_finish(erase_finish),
					.color(colour),
					.x(x),
					.y(y));
endmodule





/*
module fsm_part3(
	input clk, reset_n, 
	input [7:0] x_in,
	input [6:0] y_in,
	input [2:0] color_in,
	input [3:0] frameCounter,
	output reg ld_x, ld_y, plot, clk_out,
	output reg [3:0] pixel,
	output reg reset_n_x_y, reset_n_frame_counter,
	output reg [1:0] direction,
	output reg [2:0] color_out
	);
	
	reg [3:0] current_state, next_state;
	
	localparam S_INITIAL = 4'd0,
               S_LOAD = 4'd1,
               S_DRAW = 4'd2,
			   S_WAIT = 4'd3,
			   S_RESET = 4'd4,
			   S_ERASE = 4'd5,
			   S_UPDATE= 4'd6;
	localparam up_right = 2'b10, up_left = 2'b11,
			   down_right = 2'b00, down_left = 2'b01;
	
	always @(*)
	//state table
	begin: state_table
		case(current_state)
			S_INITIAL: next_state = S_LOAD;
			S_LOAD: next_state = S_DRAW;
			S_DRAW: next_state = (pixel == 4'b1111) ? S_WAIT : S_DRAW;
			S_WAIT: next_state = (frameCounter == 4'b1110) ? S_RESET : S_WAIT;
			S_RESET: next_state = S_ERASE;
			S_ERASE: next_state = (pixel == 4'b1111) ? S_UPDATE : S_ERASE;
			S_UPDATE: next_state = S_LOAD;
			default next_state = S_INITIAL;
		endcase
	end
	
	always @(*)
	begin: enable_signals
		ld_x = 1'b0;
		ld_y = 1'b0;
		plot = 1'b0;
		reset_n_x_y = 1'b1;
		reset_n_frame_counter = 1'b1;
		color_out = 3'b000;
		clk_out = 1'b0;
		case(current_state)
			S_INITIAL: begin reset_n_x_y = 1'b0; reset_n_frame_counter = 1'b0; direction = down_right; end
			S_LOAD: begin ld_x = 1'b1; ld_y = 1'b1; end
			S_DRAW: begin plot = 1'b1; color_out = color_in; end
			S_RESET: reset_n_frame_counter = 1'b0;
			S_ERASE: plot = 1'b1;
			S_UPDATE: begin
				if(x_in >= 8'd156 && direction[1] == 1'b0 || x_in <= 8'd0 && direction[1] == 1'b1)
					direction[1] = ~direction[1];
				if(y_in <= 7'd0 && direction[0] == 1'b1 || y_in >= 7'd116 && direction[0] == 1'b0)
					direction[0] = ~direction[0];
				clk_out = 1'b1;
			end

		endcase
	end
	
    always @(posedge clk)
    begin: counter
		if(current_state == S_RESET || current_state == S_INITIAL || !reset_n)
			pixel <= 4'b0;
		if(current_state == S_DRAW || current_state == S_ERASE)
			pixel <= pixel + 1'b1;
    end
	
	// current_state registers
    always @(posedge clk)
    begin: state_FFs
        if(!reset_n)
            current_state <= S_INITIAL;
        else
            current_state <= next_state;
    end // state_FFS
	
	
endmodule

module datapath_part3(
	input [7:0] x_in,
	input [6:0] y_in,
	input [2:0] color_in,
	input reset_n,
	input ld_x, ld_y, clk,
	input [3:0] pixel,
	output [7:0] x_out,
	output [6:0] y_out,
	output [2:0] color_out);
	// input registers
	reg [7:0] x;
	reg [6:0] y;
	always @(posedge clk, negedge reset_n) begin
		if(!reset_n) begin
			x <= 8'b0;
			y <= 7'b0;
		end
		else begin
			if(ld_x)
				x <= x_in;
			if(ld_y)
				y <= y_in;
		end
	end
	
	assign color_out = color_in;
	assign x_out = x + pixel[1:0];
	assign y_out = y + pixel[3:2];

endmodule

module x_counter(
	input clk,  left1right0, reset_n,
	output reg [7:0] x);
	always @(posedge clk, negedge reset_n) begin
		if(!reset_n) begin
			x <= 8'b0;
		end
		else  begin
			if(left1right0 == 1'b1)
				x <= x - 8'd1;
			else
				x <= x + 8'd1;
		end
	
	end
endmodule

module y_counter(
	input clk,  up1Down0, reset_n,
	output reg [6:0] y);
	always @(posedge clk, negedge reset_n) begin
		if(!reset_n) begin
			y <= 7'd60;
		end
		else  begin
			if(up1Down0 == 1'b1)
				y <= y - 7'd1;
			else
				y <= y + 7'd1;
		end
	
	end
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

//4Hz
module delay_counter_quarter(clock, reset_n, new_clock);
	input clock, reset_n;
	wire [23:0] divider;
	reg [23:0] q;
	output new_clock;
	
	assign divider = 24'd12500000;
	always @(posedge clock, negedge reset_n)
	begin
		if(reset_n == 1'b0)
			q <= divider - 1'b1;
		else
		begin
			if(q == 24'h0)
				q <= divider - 1'b1;
			else
				q <= q - 1'b1;
		end
	end
	assign new_clock = (q == 24'd0) ? 1'b1 : 1'b0;
	
endmodule

module frame_counter(
	input clock, reset_n,
	output reg [3:0] counter);
	
	always @(posedge clock, negedge reset_n) begin
		if(reset_n == 1'b0)
			counter <= 1'b0;
		else
			counter <= counter + 1'b1;
	end
endmodule

*/

/*
module divide(input clk, resetn
					input [14:0] dividend,
					input [6:0] divisor,
					output reg [14:0] quotient,
					output reg [6:0] remainder);
					
					reg [14:0] count;
					always @(posedge clk)
					begin
						if(!resetn)
							begin
								count <= 0;
								quotient <= 0;
								remainder <= 0;
							end
						else if(count < dividend)
							begin
								count <= count + 1;
								remainder <= remainder + 1;
								if(count == divisor)
									begin
										quotient <= quotient + 1;
										remainder <= 0;
									end
							end
					end
					
endmodule
					
	*/				
					
					

