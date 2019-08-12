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
							count <= {(((count[0] ^ count[3]) ^ count[5]) ^ count[9]), count[11:1]};
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
