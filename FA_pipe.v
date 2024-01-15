module FA_pipe(c_in,x_in,y_in,sum,carry,clk);
	reg pipe_1[2:0];
	reg pipe_2;
	reg pipe_3[1:0];
	input c_in, x_in, y_in,clk;
	output sum, carry;
	
		always @ (posedge clk) begin
		pipe_1[0] <= c_in;
		pipe_1[1] <= x_in;
		pipe_1[2] <= y_in;
	
		pipe_2 <= pipe_1[1] & pipe_1[2];
		
		pipe_3[0] <= pipe_1[1]^pipe_1[2]^pipe_1[0];
		pipe_3[1] <= (pipe_2&pipe_1[0])|(pipe_2)|(pipe_1[1]&pipe_1[0])|(pipe_1[2]&pipe_1[0]);
	
		end
		
	assign sum = pipe_3[0];
	assign carry = pipe_3[1];

endmodule
