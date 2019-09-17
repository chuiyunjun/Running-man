module fsm(
	input clk, reset_n,
	input draw_floors_finish, erase_finish, draw_man_finish, draw_tree_finish,
	input [3:0] frameCounter,
    input [1:0] top_shape_f,
    input [1:0] mid_shape_f,
    input [1:0] bottom_shape_f,
    input [6:0] y_w,
    input [7:0] x_w,
    input crouch,
    input draw_gameover_finish,
	output  reg drawing_floors,
	output reg erase,
	output reg ld_x,
	output reg ld_y,
	output reg ld_man_style,
	output reg update,
	output reg draw_man,
	output reg draw_tree,
	output reg reset_frame_counter,
	output reg writeEn,
    output reg gameover);
	
	localparam  S_DRAWING_FLOORS = 5'd0,
					S_LOAD_MAN= 5'd1,
				   S_DRAWING_MAN = 5'd2,
				   S_DRAWING_TREE = 5'd3,
					S_WAIT = 5'd4,
					S_RESET_FRAME_COUNTER = 5'd5,
					S_ERASE = 5'd6,
					S_UPDATE_MAN_X_Y = 5'd7,
                    S_GAMEOVER = 5'd8,
                    S_GAMEOVER_WAIT = 5'd9;
	
	
	
	reg [3:0] current_state, next_state;
    wire collision;
    collision_detector c0(
        .curr_y(y_w),
        .curr_x(x_w),
        .crouch(crouch),
        .lane1(top_shape_f),
        .lane2(mid_shape_f),
        .lane3(bottom_shape_f),
        .collision(collision)
    );

	always @(*)
	//state table
	begin: state_table
		case(current_state)
			S_DRAWING_FLOORS: next_state = draw_floors_finish? S_LOAD_MAN: S_DRAWING_FLOORS ;
			S_LOAD_MAN: next_state = S_DRAWING_TREE;
			S_DRAWING_TREE: next_state = draw_tree_finish? S_DRAWING_MAN : S_DRAWING_TREE;
			S_DRAWING_MAN : next_state = draw_man_finish ? S_WAIT : S_DRAWING_MAN ;
			S_WAIT: next_state = (frameCounter == 4'b1110) ? S_RESET_FRAME_COUNTER : S_WAIT;
			S_RESET_FRAME_COUNTER: next_state = S_ERASE;
			S_ERASE: next_state = (erase_finish)? S_UPDATE_MAN_X_Y : S_ERASE;
			S_UPDATE_MAN_X_Y: next_state = (collision) ? S_GAMEOVER : S_LOAD_MAN; 
            S_GAMEOVER: next_state = (draw_gameover_finish) ? S_GAMEOVER_WAIT : S_GAMEOVER;
            S_GAMEOVER_WAIT: next_state = S_GAMEOVER_WAIT;
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
		draw_tree = 0;
        gameover = 0;
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
			S_DRAWING_TREE:
				begin
					writeEn = 1;
					draw_tree = 1;
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
            S_GAMEOVER:
                begin
                    gameover = 1;
                    writeEn = 1;
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

