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