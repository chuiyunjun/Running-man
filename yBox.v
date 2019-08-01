//////////////////////////////////////////////////////////////////////////////////////////////////////////////
///   move 00            nothing to do, just wait for commands.                                            ///
///        01            jump to the level above, +9 ,8,7,6,5,4,3 then -2                                  ///
///        10            jump,  +7,6,5,4,3,2,1,0 then -1,2,3,4,5,6,7                                       ///
///        11            drop to the level below, -1,2,3,4,6,7,8,9                                         ///
///                                                                                                        ///
///                                                                                                        ///
///                                                                                                        ///
///                                                                                                        ///
///      TODO://   have not considered the case of dropping from the lowest level and jumping              ///
///                 from the top level.                                                                    ///    
///                                                                                                        ///
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module debouncer(input clk,
                input resetn,
                input [2:0] keys,
                input move_over,
					 input [6:0] y,
					 input man_style,
                output reg [1:0] move);

                reg move_wait;
                always @(posedge clk, negedge resetn)
                begin
                    if(!resetn)
                        begin
                            move <= 2'b00;
                            move_wait <= 1;
                        end
                    else
                        begin
                            if(move_wait)
                                begin
												if(man_style) begin
														if(!keys[0] && y > 7'd40)
															 begin
																  move <= 2'b01;
																  move_wait <= 0;
															 end
														else if(!keys[1])
															 begin
																  move <= 2'b10;
																  move_wait <= 0;
															 end
														else if(!keys[2] && y < 7'd80)
															 begin
																  move <= 2'b11;
																  move_wait <= 0;
															 end
													end
                                end
                            else if(move_over)
                                begin
                                    move_wait <= 1;
                                    move <= 2'b00;
                                end
                        end
                end
endmodule



module y_counter(input resetn,
                input update,
                input [1:0] move,
                output reg [6:0] y,
                output reg move_over
);


                reg [3:0] speed_bj;
                reg [3:0] speed_sj;
                reg [3:0] speed_drop;
                reg sj_up1down0;
                reg bj_up1down0;
                always @(negedge resetn, posedge update)
                begin
                        if(!resetn)
                            begin
                                speed_bj <= 4'd9;
                                bj_up1down0 <= 1;
                                speed_sj <= 4'd7;
                                sj_up1down0 <= 1;
                                speed_drop <= 4'd1;
                                move_over <= 0;
                                y <= 7'd108;
                            end
                        else
                            begin
                                if(move == 2'b01)
                                    begin
                                        if(bj_up1down0)
                                            begin
                                                y <= y - speed_bj; 
                                                speed_bj <= speed_bj - 1;
                                            end
                                        else
                                            begin
                                                y <= y + speed_bj; 
                                                speed_bj <= 4'd9;
                                            end

														move_over <= ((!bj_up1down0) && speed_bj == 4'd2)? 1 : 0;

                                        if(bj_up1down0 && speed_bj == 4'd3 || (!bj_up1down0) && speed_bj == 4'd2)
                                            begin
                                                bj_up1down0 <= !bj_up1down0;
                                            end
													
                                    
                                    end
                                else if(move == 2'b10)
                                    begin
                                        if(sj_up1down0)
                                            begin
                                                y <= y - speed_sj; 
                                                speed_sj <= speed_sj - 1;
                                            end
                                        else
                                            begin
                                                y <= y + speed_sj; 
                                                if(speed_sj <= 4'd6) begin speed_sj <= speed_sj + 1; end
                                            end

                                        move_over <= ((!sj_up1down0) && speed_sj == 4'd7)? 1 : 0;

                                        if(sj_up1down0 && speed_sj == 4'd1 || (!sj_up1down0) && speed_sj == 4'd7)
                                            begin
                                                sj_up1down0 <= !sj_up1down0;
                                            end
                                    end
                                else if(move == 2'b11)
                                    begin
                                        y <= y + speed_drop;
                                        if(speed_drop == 4'd4)
														begin
															speed_drop <= 4'd6;
														end
													else if(speed_drop == 4'd9)
														begin
															speed_drop <= 4'd1;
															move_over <= 1;
														end
													else
														begin
															speed_drop <= speed_drop + 4'd1;
														end
													
                                    end
                                else if(move == 2'b00)
                                    begin
                                        move_over <= 0;
                                    end
                            end
                end


endmodule


module yBox(input [2:0] keys,
            input update,
            input clk,
            input resetn,
				input man_style,
            output [6:0] y);

        wire [1:0] move; 
        wire move_over;

        debouncer d0(.clk(clk),
                    .resetn(resetn),
                    .keys(keys),
                    .move_over(move_over),
						  .y(y),
						  .man_style(man_style),
                    .move(move)
                    );

        y_counter yc0(.resetn(resetn),
                       .update(update),
                       .move(move),
                       .y(y),
                       .move_over(move_over) 
                       );
endmodule
















