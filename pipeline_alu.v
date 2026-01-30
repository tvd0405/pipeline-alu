module mult8x8 (
	input clk,
	input [15:0] a,
	input [15:0] b,
	output reg [31:0] out);

`ifdef MACRO
	reg [15:0] reg_a, reg_b;
	always @(posedge clk) begin
		reg_a <= a;
		reg_b <= b;
		out <= reg_a * reg_b;
	end
`endif
endmodule
	
module add4 (
	input clk,
	input [63:0] i1,
	input [63:0] i2,
	output [63:0] out);
	
//`ifdef MACRO
	reg [63:0] out_temp;
	assign out = out_temp;
	always @(posedge clk) begin
		out_temp <= i1 + i2;
	end
//`endif
endmodule	

module multX4 (
	input clk,
	input [31:0] a,
	input [31:0] b,
	output [31:0] mult1,
	output [31:0] mult2,
	output [31:0] mult3,
	output [31:0] mult4
);
	mult8x8 mult_1 (clk, a[15:0], b[15:0], mult1);
	mult8x8 mult_2 (clk, a[15:0], b[31:16], mult2);
	mult8x8 mult_3 (clk, a[31:16], b[15:0], mult3);
	mult8x8 mult_4 (clk, a[31:16], b[31:16], mult4);
endmodule	

module pipeline_alu (
	input clk,
	input [31:0] a,
	input [31:0] b,
	output [63:0] out
);
	wire [31:0] reg_a;
	wire [31:0] reg_b; 
	wire [31:0] mult[0:3];
	wire [63:0] mult_temp[0:1];
	//reg [63:0] reg_mult;

	//assign out = reg_mult;
	
	multX4 mult_i(clk, a, b, mult[0], mult[1], mult[2], mult[3]);
	add4 add_1(clk, {16'b0,mult[2],16'b0},{16'b0,mult[1],16'b0},mult_temp[0]);
	add4 add_2(clk, {mult[3],32'b0},{32'b0,mult[0]},mult_temp[1]);
	add4 add_5(clk, mult_temp[0], mult_temp[1], out);
	
endmodule
