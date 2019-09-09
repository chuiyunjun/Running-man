module delay_counter(clock, reset_n, new_clock);
	input clock, reset_n;
	wire [19:0] divider;
	reg [19:0] q;
	output new_clock;
	
	assign divider = 20'd833333;
	//assign divider = 25'h2;
	always @(posedge clock, negedge reset_n)
	begin
		if(reset_n == 1'b0)
			q <= divider - 1'b1;
		else
		begin
			if(q == 20'h0)
				q <= divider - 1'b1;
			else
				q <= q - 1'b1;
		end
	end
	assign new_clock = (q == 20'd0) ? 1'b1 : 1'b0;
	
endmodule