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