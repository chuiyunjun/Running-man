module comb(input CLOCK_50, resetn, 
		input [7:0] x_in,
		input [6:0] y_in,
				output writeEn,
				output [7:0] x,
				output [6:0] y,
				output [2:0] colour,
				output [5:0] q,
				output [4:0] current_state
				);
				
				
			wire drawing_floors_finish,
			erase_finish,
			drawing_floors,
			draw_man,
			erase,
			ld_x,
			ld_y,
			ld_man_style,
			reset_frame_counter,
			normal1crouch0,
			update;


			wire newClock;
			wire [3:0] frameCounter;
			
		fsm fsm0(.clk(CLOCK_50),
					.reset_n(resetn),
					.draw_floors_finish(drawing_floors_finish),
					.erase_finish(erase_finish),
					.draw_man_finish(draw_man_finish),
					.frameCounter(frameCounter),
					.drawing_floors(drawing_floors),
					.erase(erase),
					.ld_x(ld_x),
					.ld_y(ld_y),
					.ld_man_style(ld_man_style),
					.reset_frame_counter(reset_frame_counter),
					.update(update),
					.draw_man(draw_man),
					.writeEn(writeEn),
					.current_state(current_state)
					);		
		datapath d0(.clk(CLOCK_50),
					.reset_n(resetn),
					.drawing_floors(drawing_floors),
					.draw_man(draw_man),
					.erase(erase),
					.x_in(x_in),
					.y_in(y_in),
					.q(q),
					.draw_floors_finish(drawing_floors_finish),
					.draw_man_finish(draw_man_finish),
					.erase_finish(erase_finish),
					.color(colour),
					.x(x),
					.y(y),
					.ld_x(ld_x),
					.ld_y(ld_y),
					.ld_man_style(ld_man_style),
					.man_style(1'b1)
					);
		delay_counter dc0(.reset_n(resetn), .clock(CLOCK_50), .new_clock(newClock));
		frame_counter fc0(.clock(newClock), .reset_n(reset_frame_counter), .resetn(resetn), .counter(frameCounter));
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

module datapath(input clk, reset_n, drawing_floors, draw_man, erase, 
		input [7:0] x_in,
		input [6:0] y_in,
		input  ld_x, ld_y, ld_man_style, man_style,
						output reg draw_floors_finish,
						output reg draw_man_finish,
						output reg erase_finish,
						output reg [2:0] color,
						output reg [7:0] x,
						output reg [6:0] y,
						output reg [5:0] q);
				
				reg [7:0] x_original;
				reg [6:0] y_original;
				reg normal1crouch0;
				
				always @(posedge clk, negedge reset_n)
				 begin
					if(!reset_n) 
						begin
							x_original <= 8'd30;
							y_original <= 7'd108;
						end
					else 
						begin
							if(ld_x)
								x_original <= x_in;
							if(ld_y)
								y_original <= y_in;
							if(ld_man_style)
								normal1crouch0 <= man_style;
					end
				end
						
						
				reg [7:0] ground_x;
				reg [6:0] ground_y;
				always @(posedge clk)
				begin
					if(!reset_n)
						begin
							erase_finish <= 0;
							draw_man_finish <= 0;
							q <= 0;
						end

					else if(q == 6'd25)
						begin
							q <= 0;
							if(draw_man)
								begin
									draw_man_finish <= 1;
									erase_finish <= 0;
								end
							else if(erase)
								begin
									erase_finish <= 1;
									draw_man_finish <= 0;
								end
						end
					else
						begin
							q <= q + 1;
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
					if(!reset_n || drawing_floors)
							begin
								x = ground_x;
								y = ground_y;
								color = 3'b101;
							end

					 else if(draw_man || erase)
						begin
							color = draw_man ? 3'b111:3'b000;
						
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
										x = x_original + 1'd2;
										y = y_original + 3'd4;
									end
									else if(q == 6'd14) begin
										x = x_original + 2'd3;
										y = y_original + 3'd4;
									end
									else if(q == 6'd15) begin
										x = x_original + 2'd4;
										y = y_original + 3'd4;
									end	
									else if(q == 6'd16) begin
										x = x_original + 2'd5;
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
										x = x_original + 3'd6;
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

module fsm(
	input clk, reset_n,
	input draw_floors_finish, erase_finish, draw_man_finish,
	input [3:0] frameCounter,

	output  reg drawing_floors,
	output reg erase,
	output reg ld_x,
	output reg ld_y,
	output reg ld_man_style,
	output reg update,
	output reg draw_man,
	output reg reset_frame_counter,
	output reg writeEn,
output reg [4:0] current_state);
	
	localparam  S_DRAWING_FLOORS = 5'd0,
					S_LOAD_MAN= 5'd1,
				   S_DRAWING_MAN = 5'd2,
					S_WAIT = 5'd3,
					S_RESET_FRAME_COUNTER = 5'd4,
					S_ERASE = 5'd5,
					S_UPDATE_MAN_X_Y = 5'd6;
	
	
	
	reg [4:0]  next_state;

	always @(*)
	//state table
	begin: state_table
		case(current_state)
			S_DRAWING_FLOORS: next_state = draw_floors_finish? S_LOAD_MAN: S_DRAWING_FLOORS ;
			S_LOAD_MAN: next_state = S_DRAWING_MAN;
			S_DRAWING_MAN: next_state = draw_man_finish? S_WAIT : S_DRAWING_MAN;
			S_WAIT: next_state = (frameCounter == 4'b1110) ? S_RESET_FRAME_COUNTER : S_WAIT;
			S_RESET_FRAME_COUNTER: next_state = S_ERASE;
			S_ERASE: next_state = (erase_finish)? S_UPDATE_MAN_X_Y : S_ERASE;
			S_UPDATE_MAN_X_Y: next_state = S_LOAD_MAN;
			default next_state = S_DRAWING_FLOORS;
		endcase
	end
	
	always @(*)
	begin: enable_signals
		drawing_floors = 1'b0;
		writeEn = 1'b0;
		ld_x = 0;
		ld_y = 0;
		ld_man_style = 0;
		writeEn = 0;
		draw_man = 0;
		reset_frame_counter = 1;
		erase = 0;
		update = 0;
		
		case(current_state)
			S_DRAWING_FLOORS: begin drawing_floors = 1'b1; writeEn = 1'b1; end
			S_LOAD_MAN: 
				begin
					ld_x = 1;
					ld_y = 1;
					ld_man_style = 1;
				end
			S_DRAWING_MAN:
				begin
					writeEn = 1;
					draw_man = 1;
				end
			S_RESET_FRAME_COUNTER: 
				begin
					reset_frame_counter = 0;
				end
			S_ERASE:
				begin
					erase = 1;
					writeEn = 1;
				end
			S_UPDATE_MAN_X_Y:
				begin
					update = 1;
				end
		endcase
	end

    always @(posedge clk)
    begin: state_FFs
        if(!reset_n)
            current_state <= S_DRAWING_FLOORS;
        else
            current_state <= next_state;
    end 
endmodule