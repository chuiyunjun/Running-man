

module RnningMan
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

                    .y_w(y_w),
                    .x_w(x_w),
                    .crouch(!SW[9]),
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
					.man_style(SW[9]),
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
	   yBox ybox0(.clk(CLOCK_50), .resetn(resetn), .update(update), .keys(KEY[3:1]), .y(y_w));

	   wire [1:0] top_shape, mid_shape, bottom_shape;
	   wire [11:0] count;
	   rand r0(.clk(CLOCK_50), .reset_n(resetn), .count(count));
	   shape s0(.reset_n(resetn), .update(update), .count(count), .top_shape(top_shape), .mid_shape(mid_shape), .bottom_shape(bottom_shape));
	   x_counter xc0(.speed(SW[8:7]), .resetn(resetn), .update(update), .x(x_w), .ld_shape(ld_shape));
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




module collision_detector(curr_y, curr_x, crouch, lane1, lane2, lane3, collision);
	input [7:0] curr_x;
	input [6:0] curr_y;
	input crouch;
	input [1:0] lane1, lane2, lane3;
	output reg collision;


	always @(*) begin
		collision = 1'b0;

		if (20 <= curr_x && curr_x <= 40) begin // start checking
			if (lane1 == 2'b00 || lane1 == 2'b01) begin // check for small jump
				// begin to check 5 pixels
				if (curr_x <= 25 + 3 && 25 + 3 <= curr_x + 4 && 15 <= curr_y && curr_y <= 35) begin // pixel1
					collision = 1'b1;

				end
				if (curr_x <= 25 + 5 && 25 + 5 <= curr_x + 4 && 15 <= curr_y + 2 && curr_y + 2 <= 35) begin // pixel2
					collision = 1'b1;

				end
				if (curr_x <= 25 + 4 && 25 + 4 <= curr_x + 4 && 15 <= curr_y + 6 && curr_y + 6 <= 35) begin // pixel3
					collision = 1'b1;

				end
				if (curr_x <= 25 + 1 && 25 + 1 <= curr_x + 4 && 15 <= curr_y + 6 && curr_y + 6 <= 35) begin // pixel4
					collision = 1'b1;

				end
				if (curr_x <= 25 && 25 <= curr_x + 4 && 15 <= curr_y + 3 && curr_y + 3 <= 35) begin // pixel5
					collision = 1'b1;
					// troubleshoot2 = 1;
				end
			end

			else if (lane1 == 2'b10) begin // check for duck add check for y
				// begin to check 5 pixels
				if (curr_x <= 25 + 3 && 25 + 3 <= curr_x + 4 && 0 <= curr_y && curr_y <= 35 && ~crouch) begin // pixel1
					collision = 1'b1;
					//troubleshoot2 = 1;
				end
				if (curr_x <= 25 + 5 && 25 + 5 <= curr_x + 4 && 0 <= curr_y + 2 && curr_y + 2 <= 35 && ~crouch) begin // pixel2
					collision = 1'b1;
					//troubleshoot2 = 1;
				end
				if (curr_x <= 25 + 4 && 25 + 4 <= curr_x + 4 && 0 <= curr_y + 6 && curr_y + 6 <= 35 && ~crouch) begin // pixel3
					collision = 1'b1;
					//troubleshoot2 = 1;
				end
				if (curr_x <= 25 + 1 && 25 + 1 <= curr_x + 4 && 0 <= curr_y + 6 && curr_y + 6 <= 35 && ~crouch) begin // pixel4
					collision = 1'b1;
					//troubleshoot2 = 1;
				end
				if (curr_x <= 25 && 25 <= curr_x + 4 && 0 <= curr_y + 3 && curr_y + 3 <= 35 && ~crouch) begin // pixel5
					collision = 1'b1;
					//troubleshoot2 = 1;
				end
			end

			else if (lane1 == 2'b11) begin // check for wall
				// begin to check 5 pixels
				if (curr_x <= 25 + 3 && 25 + 3 <= curr_x + 4 && 0 <= curr_y && curr_y <= 35) begin // pixel1
					collision = 1'b1;
					//troubleshoot = 1;
				end
				if (curr_x <= 25 + 5 && 25 + 5 <= curr_x + 4 && 0 <= curr_y + 2 && curr_y + 2 <= 35) begin // pixel2
					collision = 1'b1;
					//troubleshoot = 1;
				end
				if (curr_x <= 25 + 4 && 25 + 4 <= curr_x + 4 && 0 <= curr_y + 6 && curr_y + 6 <= 35) begin // pixel3
					collision = 1'b1;
					//troubleshoot = 1;
				end
				if (curr_x <= 25 + 1 && 25 + 1 <= curr_x + 4 && 0 <= curr_y + 6 && curr_y + 6 <= 35) begin // pixel4
					collision = 1'b1;
					//troubleshoot = 1;
				end
				if (curr_x <= 25 && 25 <= curr_x + 4 && 0 <= curr_y + 3 && curr_y + 3 <= 35) begin // pixel5
					collision = 1'b1;
					//troubleshoot = 1;
				end
			end

			if (lane2 == 2'b00 || lane2 == 2'b01) begin // check for small jump
				// begin to check 5 pixels
				if (curr_x <= 25 + 3 && 25 + 3 <= curr_x + 4 && 55 <= curr_y && curr_y <= 75) begin // pixel1
					collision = 1'b1;
				end
				if (curr_x <= 25 + 5 && 25 + 5 <= curr_x + 4 && 55 <= curr_y + 2 && curr_y + 2 <= 75) begin // pixel2
					collision = 1'b1;
				end
				if (curr_x <= 25 + 4 && 25 + 4 <= curr_x + 4 && 55 <= curr_y + 6 && curr_y + 6 <= 75) begin // pixel3
					collision = 1'b1;
				end
				if (curr_x <= 25 + 1 && 25 + 1 <= curr_x + 4 && 55 <= curr_y + 6 && curr_y + 6 <= 75) begin // pixel4
					collision = 1'b1;
				end
				if (curr_x <= 25 && 25 <= curr_x + 4 && 55 <= curr_y + 3 && curr_y + 3 <= 75) begin // pixel5
					collision = 1'b1;
					// troubleshoot = 1'b1;
				end
			end

			else if (lane2 == 2'b10) begin // check for duck add check for y
				// begin to check 5 pixels
				if (curr_x <= 25 + 3 && 25 + 3 <= curr_x + 4 && 40 <= curr_y && curr_y <= 75 && ~crouch) begin // pixel1
					collision = 1'b1;
				end
				if (curr_x <= 25 + 5 && 25 + 5 <= curr_x + 4 && 40 <= curr_y + 2 && curr_y + 2 <= 75 && ~crouch) begin // pixel2
					collision = 1'b1;
				end
				if (curr_x <= 25 + 4 && 25 + 4 <= curr_x + 4 && 40 <= curr_y + 6 && curr_y + 6 <= 75 && ~crouch) begin // pixel3
					collision = 1'b1;
				end
				if (curr_x <= 25 + 1 && 25 + 1 <= curr_x + 4 && 40 <= curr_y + 6 && curr_y + 6 <= 75 && ~crouch) begin // pixel4
					collision = 1'b1;
				end
				if (curr_x <= 25 && 25 <= curr_x + 4 && 40 <= curr_y + 3 && curr_y + 3 <= 75 && ~crouch) begin // pixel5
					collision = 1'b1;
					// troubleshoot = 1'b1;
				end
			end

			else if (lane2 == 2'b11) begin // check for wall
				// begin to check 5 pixels
				if (curr_x <= 25 + 3 && 25 + 3 <= curr_x + 4 && 40 <= curr_y && curr_y <= 75) begin // pixel1
					collision = 1'b1;
					// troubleshoot = 1;
				end
				if (curr_x <= 25 + 5 && 25 + 5 <= curr_x + 4 && 40 <= curr_y + 2 && curr_y + 2 <= 75) begin // pixel2
					collision = 1'b1;
					// troubleshoot = 1;
				end
				if (curr_x <= 25 + 4 && 25 + 4 <= curr_x + 4 && 40 <= curr_y + 6 && curr_y + 6 <= 75) begin // pixel3
					collision = 1'b1;
					// troubleshoot = 1;
				end
				if (curr_x <= 25 + 1 && 25 + 1 <= curr_x + 4 && 40 <= curr_y + 6 && curr_y + 6 <= 75) begin // pixel4
					collision = 1'b1;
					// troubleshoot = 1;
				end
				if (curr_x <= 25 && 25 <= curr_x + 4 && 40 <= curr_y + 3 && curr_y + 3 <= 75) begin // pixel5
					collision = 1'b1;
					// troubleshoot = 1'b1;
				end
			end

			if (lane3 == 2'b00 || lane3 == 2'b01) begin // check for small jump
				// begin to check 5 pixels
				if (curr_x <= 25 + 3 && 25 + 3 <= curr_x + 4 && 95 <= curr_y && curr_y <= 115) begin // pixel1
					collision = 1'b1;

				end
				if (curr_x <= 25 + 5 && 25 + 5 <= curr_x + 4 && 95 <= curr_y + 2 && curr_y + 2 <= 115) begin // pixel2
					collision = 1'b1;

				end
				if (curr_x <= 25 + 4 && 25 + 4 <= curr_x + 4 && 95 <= curr_y + 6 && curr_y + 6 <= 115) begin // pixel3
					collision = 1'b1;

				end
				if (curr_x <= 25 + 1 && 25 + 1 <= curr_x + 4 && 95 <= curr_y + 6 && curr_y + 6 <= 115) begin // pixel4
					collision = 1'b1;

				end
				if (curr_x <= 25 && 25 <= curr_x + 4 && 95 <= curr_y + 3 && curr_y + 3 <= 115) begin // pixel5
					collision = 1'b1;

				end
			end

			else if (lane3 == 2'b10) begin // check for duck check y for lanes
				// begin to check 5 pixels
				if (curr_x <= 25 + 3 && 25 + 3 <= curr_x + 4 && 80 <= curr_y && curr_y <= 115 && ~crouch) begin // pixel1
					collision = 1'b1;
					// troubleshoot = 1'b1;
				end
				if (curr_x <= 25 + 5 && 25 + 5 <= curr_x + 4 && 80 <= curr_y + 2 && curr_y + 2 <= 115 && ~crouch) begin // pixel2
					collision = 1'b1;
					// troubleshoot = 1'b1;
				end
				if (curr_x <= 25 + 4 && 25 + 4 <= curr_x + 4 && 80 <= curr_y + 6 && curr_y + 6 <= 115 && ~crouch) begin // pixel3
					collision = 1'b1;
					// troubleshoot = 1'b1;
				end
				if (curr_x <= 25 + 1 && 25 + 1 <= curr_x + 4 && 80 <= curr_y + 6 && curr_y + 6 <= 115 && ~crouch) begin // pixel4
					collision = 1'b1;
					// troubleshoot = 1'b1;
				end
				if (curr_x <= 25 && 25 <= curr_x + 4 && 80 <= curr_y + 3 && curr_y + 3 <= 115 && ~crouch) begin // pixel5
					collision = 1'b1;
					// troubleshoot = 1'b1;
				end
			end

			else if (lane3 == 2'b11) begin // check for wall
				// begin to check 5 pixels
				if (curr_x <= 25 + 3 && 25 + 3 <= curr_x + 4 && 80 <= curr_y && curr_y <= 115) begin // pixel1
					collision = 1'b1;

				end
				if (curr_x <= 25 + 5 && 25 + 5 <= curr_x + 4 && 80 <= curr_y + 2 && curr_y + 2 <= 115) begin // pixel2
					collision = 1'b1;

				end
				if (curr_x <= 25 + 4 && 25 + 4 <= curr_x + 4 && 80 <= curr_y + 6 && curr_y + 6 <= 115) begin // pixel3
					collision = 1'b1;

				end
				if (curr_x <= 25 + 1 && 25 + 1 <= curr_x + 4 && 80 <= curr_y + 6 && curr_y + 6 <= 115) begin // pixel4
					collision = 1'b1;

				end
				if (curr_x <= 25 && 25 <= curr_x + 4 && 80 <= curr_y + 3 && curr_y + 3 <= 115) begin // pixel5
					collision = 1'b1;

				end
			end
		end
	end
endmodule

module x_counter(input [1:0] speed,
				input resetn,
				input update,
				output reg [7:0] x,
				output ld_shape);

		always @(posedge update, negedge resetn) 
		begin
			if(!resetn) 
				begin
					x <= 8'd156;
				end
			else 
				begin
					if(x <= 8'd4)
						begin
							x <= 8'd156;
						end
					else
						case(speed)
							2'b00 : x <= x - 8'd1;
							2'b01 : x <= x - 8'd2;
							2'b10 : x <= x - 8'd3;
							2'b11 : x <= x - 8'd4;
						endcase
				end
	
		end
		
		assign ld_shape = (x <= 8'd4) ? 1:0;
endmodule

module rand(input clk,
			input reset_n,
			output reg [11:0] count);
		
			always @(posedge clk)
				begin
					if(!reset_n)
						begin
							count <= 12'b1101_1111_0101;
						end
					else
						begin
							count <= count - 12'd1;
						end
				end
endmodule



module shape(input [11:0] count,
			input update, reset_n,
			output reg [1:0] top_shape,
			output reg [1:0] mid_shape,
			output reg [1:0] bottom_shape);

			always @(posedge update, negedge reset_n)
			begin
				if(!reset_n)
					begin
						top_shape = 2'b00;
						mid_shape = 2'b11;
						bottom_shape = 2'b01;
					end
				else
					begin
						top_shape = {count[10], count[1]} ^ count[3:2];
						mid_shape = {count[0] && count[4] || count[7] , count[3]&& count[6] || count[8]&& count[0]};
						bottom_shape = ((count[0] && count[4]) == 1'b1)? 2'b10:2'b00;
					end
			end
endmodule


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
///   move 00            nothing to do, just wait for commands.                                            ///
///        01            jump to the level above, +9 ,8,7,6,5,4,3 then -2                                  ///
///        10            jump,  +7,6,5,4,3,2,1,0 then -1,2,3,4,5,6,7                                       ///
///        11            drop to the level below, -1,2,3,4,6,7,8,9                                         ///
///                                                                                                        ///
///                                                                                                        ///
///                                                                                                        ///
///                                                                                                        ///
///      TODO://   have not considered the case of dropping from the lowest level and jumping              ///
///                 from the top level.                                                                    ///    
///                                                                                                        ///
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module debouncer(input clk,
                input resetn,
                input [2:0] keys,
                input move_over,
					 input [6:0] y,
					 input man_style,
                output reg [1:0] move);

                reg move_wait;
                always @(posedge clk, negedge resetn)
                begin
                    if(!resetn)
                        begin
                            move <= 2'b00;
                            move_wait <= 1;
                        end
                    else
                        begin
                            if(move_wait)
                                begin
												if(man_style) begin
														if(!keys[0] && y > 7'd40)
															 begin
																  move <= 2'b01;
																  move_wait <= 0;
															 end
														else if(!keys[1])
															 begin
																  move <= 2'b10;
																  move_wait <= 0;
															 end
														else if(!keys[2] && y < 7'd80)
															 begin
																  move <= 2'b11;
																  move_wait <= 0;
															 end
													end
                                end
                            else if(move_over)
                                begin
                                    move_wait <= 1;
                                    move <= 2'b00;
                                end
                        end
                end
endmodule



module y_counter(input resetn,
                input update,
                input [1:0] move,
                output reg [6:0] y,
                output reg move_over
);


                reg [3:0] speed_bj;
                reg [3:0] speed_sj;
                reg [3:0] speed_drop;
                reg sj_up1down0;
                reg bj_up1down0;
                always @(negedge resetn, posedge update)
                begin
                        if(!resetn)
                            begin
                                speed_bj <= 4'd9;
                                bj_up1down0 <= 1;
                                speed_sj <= 4'd7;
                                sj_up1down0 <= 1;
                                speed_drop <= 4'd1;
                                move_over <= 0;
                                y <= 7'd108;
                            end
                        else
                            begin
                                if(move == 2'b01)
                                    begin
                                        if(bj_up1down0)
                                            begin
                                                y <= y - speed_bj; 
                                                speed_bj <= speed_bj - 1;
                                            end
                                        else
                                            begin
                                                y <= y + speed_bj; 
                                                speed_bj <= 4'd9;
                                            end

														move_over <= ((!bj_up1down0) && speed_bj == 4'd2)? 1 : 0;

                                        if(bj_up1down0 && speed_bj == 4'd3 || (!bj_up1down0) && speed_bj == 4'd2)
                                            begin
                                                bj_up1down0 <= !bj_up1down0;
                                            end
													
                                    
                                    end
                                else if(move == 2'b10)
                                    begin
                                        if(sj_up1down0)
                                            begin
                                                y <= y - speed_sj; 
                                                speed_sj <= speed_sj - 1;
                                            end
                                        else
                                            begin
                                                y <= y + speed_sj; 
                                                if(speed_sj <= 4'd6) begin speed_sj <= speed_sj + 1; end
                                            end

                                        move_over <= ((!sj_up1down0) && speed_sj == 4'd7)? 1 : 0;

                                        if(sj_up1down0 && speed_sj == 4'd1 || (!sj_up1down0) && speed_sj == 4'd7)
                                            begin
                                                sj_up1down0 <= !sj_up1down0;
                                            end
                                    end
                                else if(move == 2'b11)
                                    begin
                                        y <= y + speed_drop;
                                        if(speed_drop == 4'd4)
														begin
															speed_drop <= 4'd6;
														end
													else if(speed_drop == 4'd9)
														begin
															speed_drop <= 4'd1;
															move_over <= 1;
														end
													else
														begin
															speed_drop <= speed_drop + 4'd1;
														end
													
                                    end
                                else if(move == 2'b00)
                                    begin
                                        move_over <= 0;
                                    end
                            end
                end


endmodule


module yBox(input [2:0] keys,
            input update,
            input clk,
            input resetn,
				input man_style,
            output [6:0] y);

        wire [1:0] move; 
        wire move_over;

        debouncer d0(.clk(clk),
                    .resetn(resetn),
                    .keys(keys),
                    .move_over(move_over),
						  .y(y),
						  .man_style(man_style),
                    .move(move)
                    );

        y_counter yc0(.resetn(resetn),
                       .update(update),
                       .move(move),
                       .y(y),
                       .move_over(move_over) 
                       );
endmodule



module datapath(input clk,	
					input reset_n, 
					input drawing_floors, 
					input draw_man, 
					input erase, 
					input [7:0] x_in,
					input [6:0] y_in,
					input ld_x, 
					input ld_y, 
					input ld_man_style,
					input ld_shape,
					input man_style,
					input draw_tree,
					input [1:0] top, mid, bottom,
                    input gameover,
					input update,
						output reg draw_floors_finish,
						output reg draw_man_finish,
						output reg erase_finish,
						output reg draw_tree_finish,
                        output reg draw_gameover_finish,
						output reg [2:0] color,
						output reg [7:0] x,
						output reg [6:0] y,
                        output reg [1:0] top_shape, mid_shape, bottom_shape);
				
                reg [7:0] g_x;
                reg [6:0] g_y;
                always @(posedge clk, negedge reset_n) begin
                    if (reset_n == 1'b0) begin
                        g_x <= 8'd0;
                        g_y <= 7'd0;
                        draw_gameover_finish <= 1'b0;
                    end
                    else if (gameover & g_x < 8'd159) begin
                        g_x <= g_x + 1;
                    end
                    else if (g_x == 8'd159) begin
                        g_x <= 8'd0;
                        g_y <= g_y + 1;
                    end
                    else if (g_y == 7'd119) begin
                        g_x <= 8'd0;
                        g_y <= 7'd0;
                        draw_gameover_finish <= 1'b1;
                    end
                end
                        
				reg [7:0] x_original;
				reg [6:0] y_original;
				reg [5:0] q;
				reg normal1crouch0;
				// reg [1:0] top_shape, mid_shape, bottom_shape;
				
				always @(posedge clk, negedge reset_n)
				 begin
					if(!reset_n)                      // may  be unnecessary
						begin					//
							x_original <= 8'd25;
							tree_x_r <= 8'd156;	//
							y_original <= 7'd108;	//
							top_shape <= 2'b00;
							mid_shape <= 2'b10;
							bottom_shape <= 2'b11;
						end							//
					else 							// until here
						begin
							if(ld_x)
								tree_x_r <= x_in;
							if(ld_y)
								y_original <= y_in;
							if(ld_man_style)
								normal1crouch0 <= man_style;
							if(ld_shape)
								begin
									top_shape <= top;
									mid_shape <= mid;
									bottom_shape <= bottom;
								end
					end
				end

				reg [7:0] tree_x;
				reg [6:0] tree_y;	
				reg [7:0] ground_x;
				reg [6:0] ground_y;
				reg [7:0] erase_x;
				reg [6:0] erase_y;	
				reg [7:0] tree_x_r;
				always @(posedge clk)
				begin
					if(!reset_n)
						begin
							erase_finish <= 0;
							draw_man_finish <= 0;
							q <= 0;
						end

					if(q == 6'd25)
						begin
							q <= 0;
							if(draw_man)
								begin
									draw_man_finish <= 1;
									erase_finish <= 0;
								end
						end
					else if (draw_man == 1'b1 && draw_man_finish == 1'b0)
						begin
							q <= q + 1;
						end


					if(!reset_n)
						begin
							tree_y <= 7'd0;
							draw_tree_finish <= 0;
						end
					else if(draw_tree)
						begin
							if(tree_x == tree_x_r + 8'd1)
								begin
									if(tree_y == 7'd119)
										begin
											tree_x <= tree_x_r;
											tree_y <= 0;
											draw_tree_finish <= 1;
										end
									else
										begin
											tree_x <= tree_x_r;
											tree_y <= tree_y + 1;
										end

								end
							else
								begin
									tree_x <= tree_x + 8'd1;
								end
						end
					
					if(!reset_n)
						begin
							erase_x <= 8'd0;
							erase_y <= 7'd0;
						end
					else if(erase)
						begin
							if(erase_x == 8'd159)
								begin
									if(erase_y == 8'd119)
										begin
											erase_x <= 8'd0;
											erase_y <= 7'd0;
											erase_finish <= 1;
											draw_tree_finish <= 0;
											draw_man_finish <= 0;
										end
									else
										begin
											erase_x <= 8'd0;
											erase_y <= erase_y + 1;
										end
								end
							else
								begin erase_x <= erase_x + 1; end
						end
					
					if(!reset_n)
						begin
							ground_x <= 8'd0;
							ground_y <= 7'd35;
							draw_floors_finish <= 0;
						end
					else if(drawing_floors)
						begin

							if(ground_x == 8'd159)
								begin
									ground_x <= 0;
									if(ground_y >= 7'd35 && ground_y <= 7'd38 || ground_y >= 7'd75 && ground_y <= 7'd78 || ground_y >= 7'd115 && ground_y <= 7'd118)
										begin ground_y <= ground_y + 1; end 
									else if (ground_y == 7'd39 || ground_y == 7'd79)
										begin ground_y <= ground_y + 36; end
									else if (ground_y == 7'd119)
										begin draw_floors_finish <= 1; end
								end
							else
								begin
									ground_x <= ground_x + 1;
								end
						end
				end
				
				
				always @(*)
				begin
					if(!reset_n || drawing_floors) begin color = 3'b101; end
					else if (draw_man) begin color = 3'b111; end
                    else if (gameover) begin
                        color = 3'b000;
                        color = ((58 <= g_x & g_x < 78) || (82 <= g_x & g_x < 102)) ? 3'b100 : 3'b000;
                        color = (70 >= g_y || g_y < 45) ? 3'b000 : color;
                        color = (63 <= g_x & g_x < 73 & 60 <= y & y < 65) ? 3'b000 : color;
                        color = (63 <= g_x & g_x < 68 & 55 <= y & y < 60) ? 3'b000 : color;
                        color = (63 <= g_x & g_x < 78 & 50 <= y & y < 55) ? 3'b000 : color;
                        color = (87 <= g_x & g_x < 97 & 60 <= y & y < 65) ? 3'b000 : color;
                        color = (87 <= g_x & g_x < 92 & 55 <= y & y < 60) ? 3'b000 : color;
                        color = (87 <= g_x & g_x < 102 & 50 <= y & y < 55) ? 3'b000 : color;
                    end
					else if (erase) 
						begin 
							if(y>= 7'd35 && y<= 7'd39 || y>= 7'd75 && y<= 7'd79 || y>= 7'd115 && y<= 7'd119)
								begin
									color = 3'b101;
								end
							else
								begin
									color = 3'b000;
								end
						end
					else if(draw_tree)
						begin
							if(y>= 7'd35 && y<= 7'd39 || y>= 7'd75 && y<= 7'd79 || y>= 7'd115 && y<= 7'd119)
								begin
									color = 3'b101;
								end
							else if (y>= 7'd15 && y<= 7'd29 || y>= 7'd55 && y<= 7'd69 || y>= 7'd95 && y<= 7'd109)
								begin
									color = 3'b110;
								end
							// 00 or 01 : top gap
							// 10 : bot gap
							// 11 : wall, no gap
							else if (y>= 7'd0 && y<= 7'd14)
								begin
									color = (top_shape == 2'b00 || top_shape == 2'b01)? 3'b000 : 3'b110;
								end
							else if (y>= 7'd40 && y<= 7'd54)
								begin
									color = (mid_shape == 2'b00 || mid_shape == 2'b01)? 3'b000 : 3'b110;
								end
							else if (y>= 7'd80 && y<= 7'd94)
								begin
									color = (bottom_shape == 2'b00 || bottom_shape == 2'b01)? 3'b000 : 3'b110;
								end
							else if(y >= 7'd30 && y<= 7'd34)
								begin
									color = (top_shape == 2'b10) ? 3'b000 : 3'b110;
								end
							else if(y >= 7'd70 && y<= 7'd74)
								begin
									color = (mid_shape == 2'b10) ? 3'b000 : 3'b110;
								end
							else if(y >= 7'd110 && y<= 7'd114)
								begin
									color = (bottom_shape == 2'b10) ? 3'b000 : 3'b110;
								end
						end
					
				end



				always @(*)
				begin
					if(!reset_n || drawing_floors)
							begin
								x = ground_x;
								y = ground_y;
							end
					else if(draw_tree)
						begin
							x = tree_x;
							y = tree_y;
						end
					else if(erase)
						begin
							x = erase_x;
							y = erase_y;
						end
                    else if(gameover)
                        begin
                            x = g_x;
                            y = g_y;
                        end
					else if(draw_man )
						begin

						
							if(normal1crouch0)
							begin
									if(q == 6'd0) begin
										x = x_original + 2'd3;
										y = y_original;
									end	
									else if (q == 6'd1) begin
										x = x_original + 3'd2;
										y = y_original;
									end
									else if(q == 6'd2) begin
										x = x_original + 3'd2;
										y = y_original + 3'd1;
									end
									else if(q == 6'd3) begin
										x = x_original + 2'd3;
										y = y_original + 1'b1;
									end	
									else if(q == 6'd4) begin
										x = x_original;
										y = y_original + 2'd2;
									end
									else if(q == 6'd5) begin
										x = x_original + 1'd1;
										y = y_original + 2'd2;
									end	
									else if(q == 6'd6) begin
										x = x_original + 3'd2;
										y = y_original + 2'd2;
									end	
									else if(q == 6'd7) begin
										x = x_original + 3'd3;
										y = y_original + 2'd2;
									end
									else if(q == 6'd8) begin
										x = x_original + 3'd4;
										y = y_original + 3'd2;
									end
									else if(q == 6'd9) begin
										x = x_original + 3'd5;
										y = y_original + 3'd2;
									end
									else if(q == 6'd10) begin
										x = x_original;
										y = y_original + 3'd3;
									end
									else if(q == 6'd11) begin
										x = x_original + 2'd2;
										y = y_original + 3'd3;
									end
									else if(q == 6'd12) begin
										x = x_original + 2'd3;
										y = y_original + 3'd3;
									end
									else if(q == 6'd13) begin
										x = x_original + 3'd2;
										y = y_original + 3'd4;
									end
									else if(q == 6'd14) begin
										x = x_original + 2'd3;
										y = y_original + 3'd4;
									end
									else if(q == 6'd15) begin
										x = x_original + 3'd4;
										y = y_original + 3'd4;
									end	
									else if(q == 6'd16) begin
										x = x_original + 3'd5;
										y = y_original + 3'd4;
									end
									else if(q == 6'd17) begin
										x = x_original + 1'd1;
										y = y_original + 3'd5;
									end
									else if(q == 6'd18) begin
										x = x_original + 2'd2;
										y = y_original + 3'd5;
									end
									else if(q == 6'd19) begin
										x = x_original + 3'd4;
										y = y_original + 3'd5;
									end
									else if(q == 6'd20) begin
										x = x_original + 3'd5;
										y = y_original + 3'd5;
									end	
									else if(q == 6'd21) begin
										x = x_original + 3'd1;
										y = y_original + 3'd6;
									end
									else if(q == 6'd22) begin
										x = x_original + 3'd4;
										y = y_original + 3'd6;
									end
									else if(q == 6'd23) begin
										x = x_original + 3'd6;
										y = y_original + 3'd2;
									end
									else if(q == 6'd24) begin
										x = x_original + 3'd4;
										y = y_original + 3'd4;
									end
									else if(q == 6'd25) begin
										x = x_original + 3'd3;
										y = y_original + 3'd2;

									end

								end
							else
								begin
									if(q == 6'd0) begin
										x = x_original + 3'd4;
										y = y_original + 3'd3;
									end	
									else if (q == 6'd1) begin
										x = x_original + 3'd5;
										y = y_original + 3'd3;
									end
									else if(q == 6'd2) begin
										x = x_original + 3'd6;
										y = y_original + 3'd3;
									end
									else if(q == 6'd3) begin
										x = x_original + 3'd1;
										y = y_original + 3'd4;
									end	
									else if(q == 6'd4) begin
										x = x_original + 3'd2;
										y = y_original + 3'd4;
									end
									else if(q == 6'd5) begin
										x = x_original + 3'd3;
										y = y_original + 3'd4;
									end	
									else if(q == 6'd6) begin
										x = x_original + 3'd4;
										y = y_original + 3'd4;
									end	
									else if(q == 6'd7) begin
										x = x_original + 3'd6;
										y = y_original + 3'd4;
									end
									else if(q == 6'd8) begin
										x = x_original + 3'd1;
										y = y_original + 3'd5;
									end
									else if(q == 6'd9) begin
										x = x_original + 3'd2;
										y = y_original + 3'd5;
									end
									else if(q == 6'd10) begin
										x = x_original + 3'd3;
										y = y_original + 3'd5;
									end
									else if(q == 6'd11) begin
										x = x_original + 3'd4;
										y = y_original + 3'd5;
									end
									else if(q == 6'd12) begin
										x = x_original + 3'd5;
										y = y_original + 3'd5;
									end
									else if(q == 6'd13) begin
										x = x_original + 3'd6;
										y = y_original + 3'd5;
									end
									else if(q == 6'd14) begin
										x = x_original + 3'd1;
										y = y_original + 3'd6;
									end
									else if(q == 6'd15) begin
										x = x_original + 3'd4;
										y = y_original + 3'd6;
									end	
								end
						end
				end

						
endmodule








					

