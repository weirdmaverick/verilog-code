module adder_area (a,b,c,d,sel,y);

	input [7:0] a,b,c,d;
	input sel;
	output [7:0] y;
	wire [7:0] y0, y1;
	
	assign y0 = (sel==0)?a:c;
	assign y1 = (sel==0)?b:d;
	assign y = y0+y1;
endmodule

