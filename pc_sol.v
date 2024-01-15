module reg8(data_out, data_in, inen, oen, clk, clr);
	input [7:0] data_in;
	input inen, oen, clk, clr;
	output[7:0] data_out;
	reg[7:0] st;
	always@(posedge clk, posedge clr) begin
	if(clr) st=8'b0;
	else if(inen) st=data_in;
	else st=st;
	end
	assign data_out= (oen)?st:8'bz;
endmodule

module ha(s,c,x,y);
	output s, c;
	input x, y;
	assign s=x^y;
	assign c=x&y;
endmodule

module ha_wo_carry(s,x,y);
	output s;
	input x, y;
	assign s=x^y;
endmodule

module ha8(data_in,data_out,pc_inc);
	input[7:0] data_in;
	input pc_inc;
	output [7:0] data_out;
	wire a[7:0];
	genvar i;
		generate
			ha ha0(data_out[0],a[0],pc_inc,data_in[0]);
			for(i=1;i<7;i=i+1) begin:hagen
			ha ha1(data_out[i],a[i],a[i-1],data_in[i]);
		end
	endgenerate
	ha_wo_carry ha7(data_out[7],a[6],data_in[7]);
endmodule

module pc_sol(clk,clr,pc_inc,load_pc,pc_oen,pc_input,pc_out,clk_en);
	input clk, clr, pc_inc, load_pc, pc_oen, clk_en;
	input [7:0] pc_input;
	output [7:0] pc_out;
	wire [7:0] a;
	wire [7:0] b;
	wire [7:0] c;
	wire clk_gate;
	//ha8(data_in,data_out,pc_inc);
	ha8 u0(.data_in(a),.data_out(b),.pc_inc(pc_inc));
	assign c=(load_pc)?pc_input:b; //MUX
	assign clk_gate=clk&clk_en;
	//reg8(data_out, data_in, inen, oen, clk, clr);
	reg8 u1(a,c,1'b1,1'b1,clk_gate,clr);
	assign pc_out=(pc_oen)?a:8'bz;//Tri-state buffer
endmodule
