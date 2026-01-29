module mult8x8 (
	input clk,
	input [10:0] a,
	input [10:0] b,
	output reg [21:0] out);

	reg [10:0] reg_a, reg_b;
	always @(posedge clk) begin
		reg_a <= a;
		reg_b <= b;
		out <= reg_a * reg_b;
	end
endmodule
	
module add4 (
	input clk,
	input [63:0] i1,
	input [63:0] i2,
	input [63:0] i3,
	output reg [63:0] out);
	
	always @(posedge clk) begin
		out <= i1 + i2 + i3;
	end
endmodule	

module pipeline_alu (
	input clk,
	input [31:0] a,
	input [31:0] b,
	output [63:0] out
);
	reg [31:0] reg_a;
	reg [31:0] reg_b; 
	reg [21:0] mult[0:8];
	reg [63:0] mult_temp[0:2];
	//reg [63:0] reg_mult;

	//assign out = reg_mult;
	
	mult8x8 mult_1 (clk, a[10:0], b[10:0], mult[0]);
	mult8x8 mult_2 (clk, a[10:0], b[21:11], mult[1]);
	mult8x8 mult_3 (clk, a[10:0], {1'b0,b[31:22]}, mult[2]);
	mult8x8 mult_4 (clk, a[21:11], b[10:0], mult[3]);
	mult8x8 mult_5 (clk, a[21:11], b[21:11], mult[4]);
	mult8x8 mult_6 (clk, a[21:11], {1'b0,b[31:22]}, mult[5]);
	mult8x8 mult_7 (clk, {1'b0,a[31:22]}, b[10:0], mult[6]);
	mult8x8 mult_8 (clk, {1'b0,a[31:22]}, b[21:11], mult[7]);
	mult8x8 mult_9 (clk, {1'b0,a[31:22]}, {1'b0,b[31:22]}, mult[8]);
	
	add4 add_1(clk, {20'b0,mult[2],22'b0},{20'b0,mult[4],22'b0},{20'b0,mult[6],22'b0},mult_temp[0]);
	add4 add_2(clk, {31'b0,mult[1],11'b0},{31'b0,mult[3],11'b0},{mult[8][19:0],44'b0},mult_temp[1]);
	add4 add_3(clk, {9'b0,mult[5],33'b0},{9'b0,mult[7],33'b0},{42'b0,mult[0]},mult_temp[2]);
	add4 add_5(clk, mult_temp[0], mult_temp[1], mult_temp[2], out);
	
endmodule
