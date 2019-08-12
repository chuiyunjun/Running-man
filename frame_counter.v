module frame_counter(
	input clock, reset_n, resetn,
	output reg [3:0] counter);

	always @(posedge clock, negedge reset_n, negedge resetn) begin
		if(reset_n == 1'b0 || resetn == 1'b0)
			counter <= 1'b0;
		else
			counter <= counter + 1'b1;
	end
endmodule