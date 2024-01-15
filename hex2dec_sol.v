module hex2dec_sol(h, dec_h, dec_l,clk);
	input [6:0] h;
	input clk;
	output [3:0] dec_h, dec_l;
	reg [6:0] h_reg;
	reg [3:0] dec_h_reg, dec_l_reg;
	reg [3:0] e_reg, f_reg;
	reg cout_reg;
	wire[3:0] a,b,c,d,e,f,innerdata;
	wire cout,overten;
		always @(posedge clk) begin
		h_reg <= h;
		end
	assign a[3]=h_reg[6]&h_reg[4];
	assign a[2]=(h_reg[5]&h_reg[4])|(h_reg[6]&~h_reg[4]);
	assign a[1]=(~h_reg[4])&(h_reg[6]^h_reg[5]);
	assign a[0]=(~h_reg[6])&(h_reg[5]^h_reg[4]);
	assign b[3]=h_reg[5]&h_reg[4];
	assign b[2]=(~h_reg[5])&(h_reg[6]^h_reg[4]);
	assign b[1]=(~h_reg[6])&(h_reg[5]^h_reg[4]);
	assign b[0]=0;
	assign c[3:1]=0;
	assign c[0]=h_reg[3]&(h_reg[2]|h_reg[1]);
	assign d[3]=h_reg[3]&~(h_reg[2]|h_reg[1]);
	assign d[2]=h_reg[2]&((~h_reg[3])|(h_reg[3]&h_reg[1]));
	assign d[1]=((~h_reg[3])&h_reg[1])|(h_reg[3]&h_reg[2]&(~h_reg[1]));
	assign d[0]=h_reg[0];
		always @(posedge clk) begin
		e_reg <= a+c;
		end
	//assign e = a+c;
		always @(posedge clk) begin
		{cout_reg,f_reg} <= b+d;
		end
	//assign{cout,f} = b+d;
	assign innerdata = {1'b0,{2{overten|cout_reg}},1'b0};
	assign overten = (f_reg>9);
		always @(posedge clk) begin
		dec_h_reg <= (overten|cout_reg)+e_reg;
		dec_l_reg <= f_reg+innerdata;		
		end
	assign dec_h = dec_h_reg;
	assign dec_l = dec_l_reg;
	//assign dec_h_reg = (overten|cout)+e;
	//assign dec_l = f+innerdata;
endmodule
