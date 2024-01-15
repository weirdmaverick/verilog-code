module adder_normal (a,b,c,d,sel,y);

	input [7:0] a,b,c,d;
	input sel;
	output [7:0] y;
	wire [7:0] y0, y1;
	
	assign y0 = a+b;
	assign y1 = c+d;
	assign y = (sel==0)?y0:+y1;
endmodule
