module reg4(data_out, data_in, inen, oen, clk, clr);
	output[3:0] data_out;
	input [3:0] data_in;
	input inen;
	input oen;
	input clk;
	input clr;
	reg [3:0] st;
	always @(posedge clk,posedge clr) begin
	if(clr) st=4'b0;
	else if(inen) st=data_in;
	else st=st;
	end
	assign data_out= (oen)?st:4'bz;
endmodule


module mx4to1(n,s,dout);
	input[3:0] n;
	input[1:0] s;
	output dout;
	reg a;
	always@(s, n) begin
	case(s)
	2'b00 : a=n[0];
	2'b01 : a=n[1];
	2'b10 : a=n[2];
	2'b11 : a=n[3];
	endcase
	end
	assign dout = a;
endmodule


module shreg(carry_msb,carry_lsb,c,clr,clk,data_in, data_out);
	input carry_msb, carry_lsb, clr, clk;
	input[1:0] c;
	input [3:0] data_in;
	output[3:0] data_out;
	wire[3:0] a;
	mx4to1 mx0({data_in[3],data_out[2],carry_msb,data_out[3]},c,a[3]);
	mx4to1 mx1({data_in[2],data_out[1],data_out[3],data_out[2]},c,a[2]);
	mx4to1 mx2({data_in[1],data_out[0],data_out[2],data_out[1]},c,a[1]);
	mx4to1 mx3({data_in[0],carry_lsb,data_out[1],data_out[0]},c,a[0]);
	reg4 reg4(data_out,a,1'b1, 1'b1, clk, clr);
endmodule


module acc(ah_reset,clr,clk,ah_in,ah_inen,aludata, carry_out,hs,ls,ah_out,al_out);
	input ah_reset,clr,clk,ah_inen,carry_out;
	input [1:0] hs;
	input [1:0] ls;
	input [3:0] aludata;
	input [3:0] ah_in;
	output [3:0] ah_out;
	output [3:0] al_out;
	wire [3:0] a;
	assign a=(ah_inen)?ah_in :aludata; //MUX
	shreg shreg_ah(.carry_msb(carry_out),.carry_lsb(al_out[3]),.c(hs),.clr((clr|ah_reset)),.clk(clk),.data_in(a),.data_out(ah_out));
	shreg shreg_al(ah_out[0],carry_out,ls,clr,clk,ah_out,al_out);
endmodule



