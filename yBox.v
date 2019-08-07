//////////////////////////////////////////////////////////////////////////////////////////////////////////////
///   move 00            nothing to do, just wait for commands.                                            ///
///        01            jump to the level above, +9 ,8,7,6,5,4,3 then -2                                  ///
///        10            jump,  +7,6,5,4,3,2,1 then -1,2,3,4,5,6,7                                       ///
///        11            drop to the level below, -1,2,3,4,6,7,8,9                                         ///
///                                                                                                        ///
///                                                                                                        ///
///                                                                                                        ///
///                                                                                                        ///
///      TODO://   have not considered the case of dropping from the lowest level and jumping              ///
///                 from the top level.                                                                    ///    
///                                                                                                        ///
//////////////////////////////////////////////////////////////////////////////////////////////////////////////


module decoder(input clk,
							input resetn,
							input [2:0] keys,
							input [6:0] y,
							input man_style,
							input bj_up1down0, sj_up1down0, 
							input [3:0] speed_bj,
						   input [3:0]	speed_sj,
							input [3:0] speed_drop,
							output reg [1:0] move);

			reg move_wait;
        always @(posedge clk, negedge resetn)
        begin
            if(!resetn)
                begin
                    move <= 2'b00;
                end
            else
                begin
                    if(move_wait)
                        begin
                            if(man_style) 
                                begin
                                    if(!keys[0] && y > 7'd40)
                                            begin
                                                move <= 2'b01;
                                            end
                                    else if(!keys[1])
                                            begin
                                                move <= 2'b10;
                                            end
                                    else if(!keys[2] && y < 7'd80)
                                            begin
                                                move <= 2'b11;
                                            end
												else
														begin
															move <= 2'b00;
														end
												
                                end
										else
											begin
												move <= 2'b00;
											end
                        end

                end
        end

		  
		  
        always @(posedge clk, negedge resetn)
        begin
            if(!resetn)
                begin
                    move_wait <= 1;
                end
				else if(move != 2'b00)
                begin
                            if(move == 2'b01 && ((bj_up1down0) && speed_bj == 4'd9))
                                begin
                                    move_wait <= 1;
                                end
                            else if(move == 2'b10 && ((sj_up1down0) && speed_sj == 4'd7))
                                begin
                                    move_wait <= 1;
                                end
                            else if((move == 2'b11) && (speed_drop == 4'd1))
                                 begin
                                    move_wait <= 1;
                                end
									else
											begin
												move_wait <= 0;
											end

									
                end
        end

endmodule



module yCounter(input [1:0] move,
						input update, resetn,
						output reg bj_up1down0, 
						output reg sj_up1down0, 
						output reg [3:0] speed_bj,
						output reg [3:0] speed_sj,
						output reg [3:0] speed_drop,
						output reg [6:0] y);
						
				always @(negedge resetn, posedge update)
            begin
                if(!resetn)
                    begin
                        speed_bj <= 4'd9;
                    end
                else if(move == 2'b01)
							if(speed_bj == 4'd2)
								begin
									speed_bj <= 4'd9;
								end
							else
								  begin
										speed_bj <= speed_bj - 1;
								  end
            end


            always @(negedge resetn, posedge update)
            begin
                if(!resetn)
                    begin
                        bj_up1down0 <= 1;
                    end
                else if((bj_up1down0 && speed_bj == 4'd3) || (!bj_up1down0 && speed_bj == 4'd2))
                    begin
                        bj_up1down0 <= !bj_up1down0;
                    end
            end

            always @(negedge resetn, posedge update)
            begin
                if(!resetn)
                    begin
                        speed_sj <= 4'd7;
                    end
                else if(move == 2'b10)
                    begin
                        if(sj_up1down0)
                            begin
											if(!(speed_sj == 4'd1))
												begin
													speed_sj <= speed_sj - 1;
												end
                            end
                        else
                            begin
											if(!(speed_sj == 4'd7))
												begin
													speed_sj <= speed_sj + 1;
												end
                            end
                    end
            end

            always @(negedge resetn, posedge update)
            begin
                if(!resetn)
                    begin
                        sj_up1down0 <= 1;
                    end
                else if((sj_up1down0 && speed_sj == 4'd1) || (!sj_up1down0 && speed_sj == 4'd7))
                    begin
                        sj_up1down0 <= !sj_up1down0;
                    end
            end


            always @(negedge resetn, posedge update)
            begin
                if(!resetn)
                    begin
                        speed_drop <= 4'd1;
                    end
                else if(move == 2'b11)
                    begin
                        if(speed_drop == 4'd4)
                            begin
                                speed_drop <= speed_drop + 2;
                            end
                        else if (speed_drop == 4'd9)
                            begin
                                speed_drop <= 4'd1;
                            end
                        else
                            begin
                                speed_drop <= speed_drop + 1;
                            end
                    end
            end

            always @(negedge resetn, posedge update)
            begin
                        if(!resetn)
                            begin
                                y <= 7'd108;
                            end
                        else
                            begin
                                if(move == 2'b01)
                                    begin
                                        if(bj_up1down0)
                                            begin
                                                y <= y - speed_bj; 
                                            end
                                        else
                                            begin
                                                y <= y + speed_bj; 
                                            end	          
                                    end
                                else if(move == 2'b10)
                                    begin
                                        if(sj_up1down0)
                                            begin
                                                y <= y - speed_sj; 
                                            end
                                        else
                                            begin
                                                y <= y + speed_sj; 
                                            end
                                    end
                                else if(move == 2'b11)
                                    begin
                                        y <= y + speed_drop;
                                    end
                            end
            end
						
						
endmodule

module yBox(input [2:0] keys,
				input resetn,
				input clk, update, man_style,
				output [6:0] y
				);
		
		wire bj_up1down0, sj_up1down0;
		wire [3:0] speed_bj;
		wire [3:0] speed_sj;
		wire [3:0] speed_drop;
		wire [1:0] move;

		decoder i0(.clk(clk), 
						.resetn(resetn), 
						.keys(keys),
						.y(y),
						.man_style(man_style), 
						.bj_up1down0(bj_up1down0), 
						.sj_up1down0(sj_up1down0), 
						.speed_bj(speed_bj), 
						.speed_sj(speed_sj), 
						.speed_drop(speed_drop), 
						.move(move)
						);
		
		
		yCounter y0(.move(move), 
						.update(update), 
						.resetn(resetn), 
						.bj_up1down0(bj_up1down0), 
						.sj_up1down0(sj_up1down0), 
						.speed_bj(speed_bj), 
						.speed_sj(speed_sj), 
						.speed_drop(speed_drop), 
						.y(y)
						);



endmodule

//module Box(input [2:0] keys,
//            input update,
//            input clk,
//            input resetn,
//			input man_style,
//            output reg [6:0] y);
//
//        reg [1:0] move; 
// 
//        reg [3:0] speed_bj;
//        reg [3:0] speed_sj;
//        reg [3:0] speed_drop;
//        reg sj_up1down0;
//        reg bj_up1down0;
//        reg move_wait;
//        reg move_over;
//        always @(posedge clk, negedge resetn)
//        begin
//            if(!resetn)
//                begin
//                    move <= 2'b00;
//                end
//            else
//                begin
//                    if(move_wait)
//                        begin
//                            if(man_style) 
//                                begin
//                                    if(!keys[0] && y > 7'd40)
//                                            begin
//                                                move <= 2'b01;
//                                            end
//                                    else if(!keys[1])
//                                            begin
//                                                move <= 2'b10;
//                                            end
//                                    else if(!keys[2] && y < 7'd80)
//                                            begin
//                                                move <= 2'b11;
//                                            end
//												else
//														begin
//															move <= 2'b00;
//														end
//												
//                                end
//										else
//											begin
//												move <= 2'b00;
//											end
//                        end
//
//                end
//        end
//
//        always @(posedge clk, negedge resetn)
//        begin
//            if(!resetn)
//                begin
//                    move_wait <= 1;
//                end
//				else if(move != 2'b00)
//                begin
//                            if(move == 2'b01 && ((bj_up1down0) && speed_bj == 4'd9))
//                                begin
//                                    move_wait <= 1;
//                                end
//                            else if(move == 2'b10 && ((sj_up1down0) && speed_sj == 4'd7))
//                                begin
//                                    move_wait <= 1;
//                                end
//                            else if((move == 2'b11) && (speed_drop == 4'd1))
//                                 begin
//                                    move_wait <= 1;
//                                end
//									else
//											begin
//												move_wait <= 0;
//											end
//
//									
//                end
//        end
//
//
//
//            always @(negedge resetn, posedge update)
//            begin
//                if(!resetn)
//                    begin
//                        speed_bj <= 4'd9;
//                    end
//                else if(move == 2'b01)
//							if(speed_bj == 4'd2)
//								begin
//									speed_bj <= 4'd9;
//								end
//							else
//								  begin
//										speed_bj <= speed_bj - 1;
//								  end
//            end
//
//
//            always @(negedge resetn, posedge update)
//            begin
//                if(!resetn)
//                    begin
//                        bj_up1down0 <= 1;
//                    end
//                else if((bj_up1down0 && speed_bj == 4'd3) || (!bj_up1down0 && speed_bj == 4'd2))
//                    begin
//                        bj_up1down0 <= !bj_up1down0;
//                    end
//            end
//
//            always @(negedge resetn, posedge update)
//            begin
//                if(!resetn)
//                    begin
//                        speed_sj <= 4'd7;
//                    end
//                else if(move == 2'b10)
//                    begin
//                        if(sj_up1down0)
//                            begin
//											if(!(speed_sj == 4'd1))
//												begin
//													speed_sj <= speed_sj - 1;
//												end
//                            end
//                        else
//                            begin
//											if(!(speed_sj == 4'd7))
//												begin
//													speed_sj <= speed_sj + 1;
//												end
//                            end
//                    end
//            end
//
//            always @(negedge resetn, posedge update)
//            begin
//                if(!resetn)
//                    begin
//                        sj_up1down0 <= 1;
//                    end
//                else if((sj_up1down0 && speed_sj == 4'd1) || (!sj_up1down0 && speed_sj == 4'd7))
//                    begin
//                        sj_up1down0 <= !sj_up1down0;
//                    end
//            end
//
//
//            always @(negedge resetn, posedge update)
//            begin
//                if(!resetn)
//                    begin
//                        speed_drop <= 4'd1;
//                    end
//                else if(move == 2'b11)
//                    begin
//                        if(speed_drop == 4'd4)
//                            begin
//                                speed_drop <= speed_drop + 2;
//                            end
//                        else if (speed_drop == 4'd9)
//                            begin
//                                speed_drop <= 4'd1;
//                            end
//                        else
//                            begin
//                                speed_drop <= speed_drop + 1;
//                            end
//                    end
//            end
//
//            always @(negedge resetn, posedge update)
//            begin
//                        if(!resetn)
//                            begin
//                                y <= 7'd108;
//                            end
//                        else
//                            begin
//                                if(move == 2'b01)
//                                    begin
//                                        if(bj_up1down0)
//                                            begin
//                                                y <= y - speed_bj; 
//                                            end
//                                        else
//                                            begin
//                                                y <= y + speed_bj; 
//                                            end	          
//                                    end
//                                else if(move == 2'b10)
//                                    begin
//                                        if(sj_up1down0)
//                                            begin
//                                                y <= y - speed_sj; 
//                                            end
//                                        else
//                                            begin
//                                                y <= y + speed_sj; 
//                                            end
//                                    end
//                                else if(move == 2'b11)
//                                    begin
//                                        y <= y + speed_drop;
//                                    end
//                            end
//            end
//endmodule








