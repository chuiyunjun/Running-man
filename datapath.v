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
					 localparam COLOR_FLOOR = 3'b010;
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
					if(!reset_n || drawing_floors) begin color = COLOR_FLOOR; end
					else if (draw_man) begin color = 3'b111; end
                    else if (gameover) begin
                        color = 3'b000;
                        color = ((58 <= g_x & g_x < 78) || (82 <= g_x & g_x < 102)) ? 3'b100 : 3'b000;
                        color = (70 <= g_y || g_y < 45) ? 3'b000 : color;
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
									color = COLOR_FLOOR;
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
									color = COLOR_FLOOR;
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
