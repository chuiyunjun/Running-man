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
        .enable(start),
        .bigorsmall(bigorsmall)
    );
    // reg [3:0] current_state, next_state;

    localparam WAIT            = 3'd0,
               JUMP_WAIT       = 3'd1,
               CALC_JUMP       = 3'd2,
               CROUCH          = 3'd3,
               DROP            = 3'd4;

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
                             next_state = DROP;
                         end
                  end
            JUMP_WAIT: next_state = (inputkeys[0] == 1'b1) ? JUMP_WAIT : CALC_JUMP;
            CALC_JUMP: next_state = WAIT; 
            CROUCH: next_state = WAIT;
            DROP: next_state = WAIT;
            default: next_state = WAIT;
        endcase
    end

    always @(*)
    begin: enable_singals
        movement = 3'b000;
        start = 1'b0;
        case (current_state)
            JUMP_WAIT: start = 1'b1; 
            CALC_JUMP: movement = (bigorsmall == 1'b1) ? 3'b001 : 3'b010;
            CROUCH: movement = 3'b011;
            DROP: movement = 3'b100;
        endcase
    end

    always @(posedge clk)
    begin: state_FFs
        if(reset)
            begin
                current_state <= WAIT;
                start <= 1'b0;
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
    reg [30:0] timer; 
    always @(posedge clk)
    begin 
        if (reset)
            timer <= 30'd0;
        if (enable == 1'b0)
            begin
                if (timer > 30'd4)// certain number
                    begin
                        bigorsmall <= 1'b1;
                    end
                else if (timer <= 30'd4)
                    begin
                        bigorsmall <= 1'b0;
                    end
                timer <= 30'd0;
            end
        else if (enable == 1'b1)
            begin
                timer <= timer + 1;
            end
    end
endmodule
