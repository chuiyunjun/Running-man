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

	always @(posedge update, operation)
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

    always @(posedge update, operation)
    begin: enable_signals
        yout = 7'd12;
        case (current_state)
            BIG_JUMP0    : yout = yin + 9;
			BIG_JUMP1    : yout = yin + 8;
			BIG_JUMP2    : yout = yin + 7;
			BIG_JUMP3    : yout = yin + 6;
			BIG_JUMP4    : yout = yin + 5;
			BIG_JUMP5    : yout = yin + 4;
			BIG_JUMP6    : yout = yin + 3;
			BIG_JUMP7    : yout = yin + 2;
			BIG_JUMP8    : yout = yin + 1;
			BIG_JUMP9    : yout = yin - 5;
			SMALL_JUMP0  : yout = yin + 7;
			SMALL_JUMP1  : yout = yin + 6;
			SMALL_JUMP2  : yout = yin + 5;
			SMALL_JUMP3  : yout = yin + 4;
			SMALL_JUMP4  : yout = yin + 3;
			SMALL_JUMP5  : yout = yin + 2;
			SMALL_JUMP6  : yout = yin + 1;
			SMALL_JUMP7  : yout = yin;
			SMALL_JUMP8  : yout = yin - 1;
			SMALL_JUMP9  : yout = yin - 2;
			SMALL_JUMP10 : yout = yin - 3;
			SMALL_JUMP11 : yout = yin - 4;
			SMALL_JUMP12 : yout = yin - 5;
			SMALL_JUMP13 : yout = yin - 6;
			SMALL_JUMP14 : yout = yin - 7;
			DROP0        : yout = yin - 1;
			DROP1	     : yout = yin - 2;
			DROP2        : yout = yin - 3;
			DROP3        : yout = yin - 4;
			DROP4        : yout = yin - 5;
			DROP5        : yout = yin - 6;
			DROP6        : yout = yin - 7;
			DROP7        : yout = yin - 8;
			DROP8        : yout = yin - 4;
            WAIT         : yout = yin;
        endcase
    end

    always @(posedge clk, negedge reset)
    begin: state_FFs
        if(~reset)
            begin
                yout <= 7'd12;
                current_state <= WAIT;
                next_state <= WAIT;
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
                yout <= 7'd12;
            end
        else
            begin
                yout <= yin;
            end
    end
endmodule

