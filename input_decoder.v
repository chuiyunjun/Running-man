module input_decoder(clk, reset, inputkeys, movement);
    input [2:0] inputkeys;
    input clk;
    input reset;
    output reg [2:0] movement;
    wire bigorsmall;
	 reg start;
    // assign start = 1'b0;
    reg [3:0] current_state, next_state;
    timer u0(
        .clk(clk),
        .reset(reset),
        .enable(start_w),
        .bigorsmall(bigorsmall)
    );
    // reg [3:0] current_state, next_state;
	wire start_w;
	assign start_w = start;
    localparam WAIT            = 3'd0,
               JUMP_WAIT       = 3'd1,
               JUMP_SYNC       = 3'd2,
               CALC_JUMP       = 3'd3,
               CROUCH          = 3'd4,
               DROP_WAIT       = 3'd5,
               DROP            = 3'd6;

    always @(*)
    begin: state_table
        case (current_state)
             WAIT: begin
                      if (inputkeys == 3'b001) // jump
                          begin
                              next_state = JUMP_WAIT;
                          end
                      else if (inputkeys == 3'b010) // crouch
                          begin
                              next_state = CROUCH;
                          end
                      else if (inputkeys == 3'b100) // drop
                         begin
                             next_state = DROP_WAIT;
                         end
                  end
            JUMP_WAIT: next_state = (inputkeys[0] == 1'b1) ? JUMP_WAIT : JUMP_SYNC;
            JUMP_SYNC: next_state = CALC_JUMP;
            CALC_JUMP: next_state = WAIT; 
            CROUCH: next_state = (inputkeys[1] == 1'b1) ? CROUCH : WAIT;
            DROP_WAIT: next_state = (inputkeys[2] == 1'b0) ? DROP : DROP_WAIT;
            DROP: next_state = WAIT;
            default: next_state = WAIT;
        endcase
    end

    always @(*)
    begin: enable_signals
	movement = 3'b000;
	start = 1'b0;
        case(current_state)
				WAIT: start = 1'b0;
            JUMP_WAIT: begin start = 1'b1;  movement = 3'b000; end
            CALC_JUMP: begin movement = (bigorsmall == 1'b1) ? 3'b001 : 3'b010; 		  start = 1'b0; end
            CROUCH: begin movement = 3'b011; 		  start = 1'b0; end
            DROP: begin movement = 3'b100; 		  start = 1'b0; end 
        endcase
    end

    always @(posedge clk, negedge reset)
    begin: state_FFs
        if(~reset)
            begin
                current_state <= WAIT;
            end
        else
            begin
                current_state <= next_state;
            end
    end
	 

endmodule

module timer(clk, reset, enable, bigorsmall);
    input clk;
    input enable;
    input reset;
    output reg bigorsmall;
    reg [30:0] tim; 
    always @(posedge clk, negedge reset)
    begin 
        if (~reset)
            tim <= 30'd0;
        else if (enable == 1'b0)
            begin
                if (tim > 30'd10000000)// certain number
                    begin
                        bigorsmall <= 1'b1;
                    end
                else if (tim <= 30'd9999999)
                    begin
                        bigorsmall <= 1'b0;
                    end
                tim <= 30'd0;
            end
        else if (enable == 1'b1)
            begin
                tim <= tim + 1;
            end
    end
endmodule

