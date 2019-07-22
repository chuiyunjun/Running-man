module fsm(
	input clk, reset_n,
	input draw_floors_finish, erase_finish,
	input reg [3:0] frameCounter,

	output  reg drawing_floors,
	output reg erase,
	output reg ld_x,
	output reg ld_y,
	output reg ld_man_style,
	output reg update,
	output reg reset_frame_counter,
	output reg writeEn);
	
	localparam  S_DRAWING_FLOORS = 5'd0,
					S_LOAD_MAN= 5'd1,
				   S_DRAWING_MAN = 5'd2,
					S_WAIT = 5'd3,
					S_RESET_FRAME_COUNTER = 5'd4,
					S_ERASE = 5'd5
					S_UPDATE_MAN_X_Y = 5'd6;
	
	
	
	reg [3:0] current_state;
	
	always @(*)
	//state table
	begin: state_table
		case(current_state)
			S_DRAWING_FLOORS: next_state = draw_floors_finish? S_LOAD_MAN: S_DRAWING_FLOORS ;
			S_LOAD_MAN: next_state = S_DRAWING_MAN;
			S_DRAWING_MAN: next_state = drawing_man_finish? S_WAIT : S_DRAWING_MAN;
			S_WAIT: next_state = (frameCounter == 4'b1110) ? S_ERASE : S_RESET_FRAME_COUNTER;
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