module comb(input CLOCK_50, resetn, 
		input [7:0] x_in,
		input [3:1] KEY, 
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
			wire [6:0] y_in;
			wire [2:0] move;
			movement m0(.clk(CLOCK_50), .operation(move), .reset(resetn), .update(update), .yout(y_in));

			

	input_decoder INPUT(
		.clk(CLOCK_50),
		.reset(resetn),
		.inputkeys(~KEY[3:1]),
		.movement(move)
	);

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
					input man_style,
						output reg draw_floors_finish,
						output reg draw_man_finish,
						output reg erase_finish,
						output reg [2:0] color,
						output reg [7:0] x,
						output reg [6:0] y);
				
				reg [7:0] x_original;
				reg [6:0] y_original;
				reg [5:0] q;
				reg normal1crouch0;
				
				always @(posedge clk, negedge reset_n)
				 begin
					if(!reset_n) 
						begin
							x_original <= 8'd25;
							y_original <= 7'd25;
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

					if(q == 6'd25)
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
					else if (draw_man == 1'b1 && draw_man_finish == 1'b0|| erase == 1'b1 && erase_finish == 1'b0)
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
								color = 3'b101;//////////////////////////////color
							end

					 else if(draw_man || erase)
						begin
							color = draw_man ? 3'b111:3'b000;///////////////////////color
						
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


module input_decoder(clk, reset, inputkeys, movement);
    input [2:0] inputkeys;
    input clk;
    input reset;
    output reg [2:0] movement;
    wire bigorsmall;
	 reg start;
    // assign start = 1'b0;
    reg [3:0] current_state, next_state;
    timer u0(
        .clk(clk),
        .reset(reset),
        .enable(start),
        .bigorsmall(bigorsmall)
    );
    // reg [3:0] current_state, next_state;

    localparam WAIT            = 3'd0,
               JUMP_WAIT       = 3'd1,
               JUMP_SYNC       = 3'd2,
               CALC_JUMP       = 3'd3,
               CROUCH          = 3'd4,
               DROP_WAIT       = 3'd5,
               DROP            = 3'd6;

    always @(*)
    begin: state_table
        case (current_state)
             WAIT: begin
                      if (inputkeys == 3'b001) // jump
                          begin
                              next_state = JUMP_WAIT;
                          end
                      else if (inputkeys == 3'b010) // crouch
                          begin
                              next_state = CROUCH;
                          end
                      else if (inputkeys == 3'b100) // drop
                         begin
                             next_state = DROP_WAIT;
                         end
                  end
            JUMP_WAIT: next_state = (inputkeys[0] == 1'b1) ? JUMP_WAIT : JUMP_SYNC;
            JUMP_SYNC: next_state = CALC_JUMP;
            CALC_JUMP: next_state = WAIT; 
            CROUCH: next_state = (inputkeys[1] == 1'b1) ? CROUCH : WAIT;
            DROP_WAIT: next_state = (inputkeys[2] == 1'b0) ? DROP : DROP_WAIT;
            DROP: next_state = WAIT;
            default: next_state = WAIT;
        endcase
    end

    always @(*)
    begin: enable_signals
	movement = 3'b000;
	start = 1'b0;
        case(current_state)
				WAIT: start = 1'b0;
            JUMP_WAIT: begin start = 1'b1;  movement = 3'b000; end
            CALC_JUMP: begin movement = (bigorsmall == 1'b1) ? 3'b001 : 3'b010; 		  start = 1'b0; end
            CROUCH: begin movement = 3'b011; 		  start = 1'b0; end
            DROP: begin movement = 3'b100; 		  start = 1'b0; end 
        endcase
    end

    always @(posedge clk, negedge reset)
    begin: state_FFs
        if(~reset)
            begin
                current_state <= WAIT;
            end
        else
            begin
                current_state <= next_state;
            end
    end
	 

endmodule

module timer(clk, reset, enable, bigorsmall);
    input clk;
    input enable;
    input reset;
    output reg bigorsmall;
    reg [30:0] tim; 
    always @(posedge clk, negedge reset)
    begin 
        if (~reset)
            tim <= 30'd0;
        else if (enable == 1'b0)
            begin
                if (tim > 30'd10000000)// certain number
                    begin
                        bigorsmall <= 1'b1;
                    end
                else if (tim <= 30'd9999999)
                    begin
                        bigorsmall <= 1'b0;
                    end
                tim <= 30'd0;
            end
        else if (enable == 1'b1)
            begin
                tim <= tim + 1;
            end
    end
endmodule

module movement(clk, operation, reset, update, yout);
	input clk;
	input [2:0] operation;
	input reset;
	input update;
	output [6:0] yout;
	wire [6:0] regin, regout;
	yvalueupdater Y1(
		.clk(clk),
		.operation(operation),
		.reset(reset),
		.update(update),
		.yin(regout),
		.yout(regin)
	);

	yregister YREG(
		.yin(regin),
		.update(update),
		.clk(clk),
		.reset(reset),
		.yout(regout)
	);
	assign yout = regout;
endmodule
	
module yvalueupdater(clk, operation, reset, update, yin, yout);
	input [2:0] operation;
	input update;
	input clk;
	input reset;
	input [6:0] yin;
	output reg [6:0] yout;
	reg [3:0] current_state, next_state;
	localparam  WAIT          = 6'd0,
				BIG_JUMP0     = 6'd1,
				BIG_JUMP1     = 6'd2,
				BIG_JUMP2     = 6'd3,
				BIG_JUMP3     = 6'd4,
				BIG_JUMP4     = 6'd5,
				BIG_JUMP5     = 6'd6,
				BIG_JUMP6     = 6'd7,
				BIG_JUMP7     = 6'd8,
				BIG_JUMP8     = 6'd9,
				BIG_JUMP9     = 6'd10,
	        	SMALL_JUMP0   = 6'd11,
	        	SMALL_JUMP1   = 6'd12,
	        	SMALL_JUMP2   = 6'd13,
	        	SMALL_JUMP3   = 6'd14,
	        	SMALL_JUMP4   = 6'd15,
	        	SMALL_JUMP5   = 6'd16,
	        	SMALL_JUMP6   = 6'd17,
	        	SMALL_JUMP7   = 6'd18,
	        	SMALL_JUMP8   = 6'd19,
	        	SMALL_JUMP9   = 6'd20,
	        	SMALL_JUMP10  = 6'd21,
	        	SMALL_JUMP11  = 6'd22,
	        	SMALL_JUMP12  = 6'd23,
	        	SMALL_JUMP13  = 6'd24,
	        	SMALL_JUMP14  = 6'd25,
				DROP0         = 6'd26,
				DROP1	      = 6'd27,
				DROP2         = 6'd28,
				DROP3         = 6'd29,
				DROP4         = 6'd30,
				DROP5         = 6'd31,
				DROP6         = 6'd32,
				DROP7         = 6'd33,
				DROP8         = 6'd34;

	always @(posedge update, posedge operation)
    begin: state_table
        case (current_state)
             WAIT: begin
                      if (operation == 3'b001) // big jump
                          begin
                              next_state = BIG_JUMP0;
                          end
                      else if (operation == 3'b010) // small jump
                          begin
                              next_state = SMALL_JUMP0;
                          end
                      else if (operation == 3'b100) // drop
                         begin
                             next_state = DROP0;
                         end
                      else
                         begin
                             next_state = WAIT;
                         end
                  end
            BIG_JUMP0: next_state = (update) ? BIG_JUMP1 : BIG_JUMP0;
			BIG_JUMP1: next_state = (update) ? BIG_JUMP2 : BIG_JUMP1;
			BIG_JUMP2: next_state = (update) ? BIG_JUMP3 : BIG_JUMP2;
			BIG_JUMP3: next_state = (update) ? BIG_JUMP4 : BIG_JUMP3;
			BIG_JUMP4: next_state = (update) ? BIG_JUMP5 : BIG_JUMP4;
			BIG_JUMP5: next_state = (update) ? BIG_JUMP6 : BIG_JUMP5;
			BIG_JUMP6: next_state = (update) ? BIG_JUMP7 : BIG_JUMP6;
			BIG_JUMP7: next_state = (update) ? BIG_JUMP8 : BIG_JUMP7;
			BIG_JUMP8: next_state = (update) ? BIG_JUMP9 : BIG_JUMP8;
            BIG_JUMP9: next_state = (update) ? WAIT : BIG_JUMP9;
			SMALL_JUMP0: next_state = (update) ? SMALL_JUMP1 : SMALL_JUMP0;
			SMALL_JUMP1: next_state = (update) ? SMALL_JUMP2 : SMALL_JUMP1;
			SMALL_JUMP2: next_state = (update) ? SMALL_JUMP3 : SMALL_JUMP2;
			SMALL_JUMP3: next_state = (update) ? SMALL_JUMP4 : SMALL_JUMP3;
			SMALL_JUMP4: next_state = (update) ? SMALL_JUMP5 : SMALL_JUMP4;
			SMALL_JUMP5: next_state = (update) ? SMALL_JUMP6 : SMALL_JUMP5;
			SMALL_JUMP6: next_state = (update) ? SMALL_JUMP7 : SMALL_JUMP6;
			SMALL_JUMP7: next_state = (update) ? SMALL_JUMP8 : SMALL_JUMP7;
			SMALL_JUMP8: next_state = (update) ? SMALL_JUMP9 : SMALL_JUMP8;
			SMALL_JUMP9: next_state = (update) ? SMALL_JUMP10 : SMALL_JUMP9;
			SMALL_JUMP10: next_state = (update) ? SMALL_JUMP11 : SMALL_JUMP10;
			SMALL_JUMP11: next_state = (update) ? SMALL_JUMP12 : SMALL_JUMP11;
			SMALL_JUMP12: next_state = (update) ? SMALL_JUMP13 : SMALL_JUMP12;
			SMALL_JUMP13: next_state = (update) ? SMALL_JUMP14 : SMALL_JUMP13;
			SMALL_JUMP14: next_state = (update) ? WAIT : SMALL_JUMP14;
			DROP0: next_state = (update) ? DROP1 : DROP0;
			DROP1: next_state = (update) ? DROP2 : DROP1;
			DROP2: next_state = (update) ? DROP3 : DROP2;
			DROP3: next_state = (update) ? DROP4 : DROP3;
			DROP4: next_state = (update) ? DROP5 : DROP4;
			DROP5: next_state = (update) ? DROP6 : DROP5;
			DROP6: next_state = (update) ? DROP7 : DROP6;
			DROP7: next_state = (update) ? DROP8 : DROP7;
			DROP8: next_state = (update) ? WAIT : DROP8;
            default: next_state = WAIT;
        endcase
    end

    always @(posedge update, posedge operation, negedge reset)
    begin: enable_signals
		yout = 7'd108;
        case (current_state)
            BIG_JUMP0    : yout = yin - 9;
			BIG_JUMP1    : yout = yin - 8;
			BIG_JUMP2    : yout = yin - 7;
			BIG_JUMP3    : yout = yin - 6;
			BIG_JUMP4    : yout = yin - 5;
			BIG_JUMP5    : yout = yin - 4;
			BIG_JUMP6    : yout = yin - 3;
			BIG_JUMP7    : yout = yin - 2;
			BIG_JUMP8    : yout = yin - 1;
			BIG_JUMP9    : yout = yin + 5;
			SMALL_JUMP0  : yout = yin - 7;
			SMALL_JUMP1  : yout = yin - 6;
			SMALL_JUMP2  : yout = yin - 5;
			SMALL_JUMP3  : yout = yin - 4;
			SMALL_JUMP4  : yout = yin - 3;
			SMALL_JUMP5  : yout = yin - 2;
			SMALL_JUMP6  : yout = yin - 1;
			SMALL_JUMP7  : yout = yin;
			SMALL_JUMP8  : yout = yin + 1;
			SMALL_JUMP9  : yout = yin + 2;
			SMALL_JUMP10 : yout = yin + 3;
			SMALL_JUMP11 : yout = yin + 4;
			SMALL_JUMP12 : yout = yin + 5;
			SMALL_JUMP13 : yout = yin + 6;
			SMALL_JUMP14 : yout = yin + 7;
			DROP0        : yout = yin + 1;
			DROP1	     : yout = yin + 2;
			DROP2        : yout = yin + 3;
			DROP3        : yout = yin + 4;
			DROP4        : yout = yin + 5;
			DROP5        : yout = yin + 6;
			DROP6        : yout = yin + 7;
			DROP7        : yout = yin + 8;
			DROP8        : yout = yin + 4;
            WAIT         : yout = yin;
        endcase
		 end

    always @(posedge clk, negedge reset)
    begin: state_FFs
        if(~reset)
            begin
                current_state <= WAIT;
            end
        else
            begin
                current_state <= next_state;
            end
    end

endmodule

module yregister(yin, update, clk, reset, yout);
	input [6:0] yin;
	input update;
	input clk;
	input reset;
	output reg [6:0] yout;
	always @(posedge clk, negedge reset)
    begin: state_FFs
        if(~reset)
            begin
                yout <= 7'd108;
            end
        else
            begin
                yout <= yin;
            end
    end
endmodule

