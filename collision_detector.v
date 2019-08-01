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
