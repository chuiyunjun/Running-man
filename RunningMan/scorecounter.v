module scorecounter(clk, reset, gameover, hex0, hex1, hex2, hex3, hex4, hex5);
    input clk;
    input reset;
    input gameover;
    output [6:0] hex0, hex1, hex2, hex3, hex4, hex5;
    wire pulse;
    wire [3:0] val0, val1, val2, val3, val4, val5;
    wire c0, c1, c2, c3, c4, c5;
    ratedivider r0(
        .clk(clk),
        .reset(reset),
        .gameover(gameover),
        .signal(pulse)
    );
    
    decimalreg v0(
        .clk(pulse),
        .reset(reset),
        .out(val0),
        .pulse(c0)
    );

    decimalreg v1(
        .clk(c0),
        .reset(reset),
        .out(val1),
        .pulse(c1)
    );

    decimalreg v2(
        .clk(c1),
        .reset(reset),
        .out(val2),
        .pulse(c2)
    );

    decimalreg v3(
        .clk(c2),
        .reset(reset),
        .out(val3),
        .pulse(c3)
    );
    
    decimalreg v4(
        .clk(c3),
        .reset(reset),
        .out(val4),
        .pulse(c4)
    );

    decimalreg v5(
        .clk(c4),
        .reset(reset),
        .out(val5),
        .pulse(c5)
    );
    
    hex_decoder h0(
        .hex_digit(val0),
        .segments(hex0)
    );

    hex_decoder h1(
        .hex_digit(val1),
        .segments(hex1)
    );

    hex_decoder h2(
        .hex_digit(val2),
        .segments(hex2)
    );

    hex_decoder h3(
        .hex_digit(val3),
        .segments(hex3)
    );

    hex_decoder h4(
        .hex_digit(val4),
        .segments(hex4)
    );

    hex_decoder h5(
        .hex_digit(val5),
        .segments(hex5)
    );
endmodule

module ratedivider(clk, reset, gameover, signal);
    input clk;
    input reset;
    input gameover;
    output reg signal;
    reg [25:0] counter;
    reg go;
    always @(posedge clk, negedge reset, posedge gameover) begin
        if (gameover) begin
            go <= 1'b0;
        end
		  else begin
							  if (reset == 1'b0) begin
									counter <= 26'b0;
									signal <= 1'b0;
									go <= 1'b1;
							  end
							  else if (go & (counter < 26'd49999999)) begin
									counter <= counter + 1;
									signal <= 1'b0;
							  end
							  else if (go & (counter == 26'd49999999)) begin
									counter <= 26'b0;
									signal <= 1'b1;
							  end
			end
    end 
endmodule

module decimalreg(clk, reset, out, pulse);
    input clk;
    input reset;
    output reg [3:0] out;
    output reg pulse;
    always @(posedge clk, negedge reset) begin
        if (reset == 1'b0) begin
            out <= 4'b0;
            pulse <= 1'b0;
        end
        else if (out < 4'd9) begin
            out <= out + 1;
            pulse <= 1'b0;
        end
        else if (out == 4'd9) begin
            out <= 4'b0;
            pulse <= 1'b1;
        end
    end
endmodule

module hex_decoder(hex_digit, segments);
    input [3:0] hex_digit;
    output reg [6:0] segments;
   
    always @(*)
        case (hex_digit)
            4'h0: segments = 7'b100_0000;
            4'h1: segments = 7'b111_1001;
            4'h2: segments = 7'b010_0100;
            4'h3: segments = 7'b011_0000;
            4'h4: segments = 7'b001_1001;
            4'h5: segments = 7'b001_0010;
            4'h6: segments = 7'b000_0010;
            4'h7: segments = 7'b111_1000;
            4'h8: segments = 7'b000_0000;
            4'h9: segments = 7'b001_1000;
            4'hA: segments = 7'b000_1000;
            4'hB: segments = 7'b000_0011;
            4'hC: segments = 7'b100_0110;
            4'hD: segments = 7'b010_0001;
            4'hE: segments = 7'b000_0110;
            4'hF: segments = 7'b000_1110;   
            default: segments = 7'h7f;
        endcase
endmodule   
