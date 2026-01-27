module pipeline_alu (
	input clk,
	input rst,
	input signed [8:0] a,
	input signed [8:0] b,
	input signed [8:0] c,
	input signed [8:0] d,
	output signed [19:0] out
);
	reg signed [8:0] reg_a;
	reg signed [8:0] reg_b; 
	reg signed [8:0] reg_c, reg_cd; 
	reg signed [8:0] reg_d, reg_dd, reg_dd2; 
	reg signed [9:0] reg_add;
	reg signed [10:0] reg_sub; 
	reg signed [19:0] reg_mult;

	assign out = reg_mult;
	
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			reg_add <= 0;
			reg_sub <= 0;
			reg_mult <= 0;
		end else begin
			reg_a <= a;
			reg_b <= b;
			reg_c <= c;
			reg_d <= d;
			reg_dd <= reg_d;
			reg_dd2 <= reg_dd;
			reg_cd <= reg_c;
			reg_add <= reg_a + reg_b;
			reg_sub <= reg_add - reg_cd;				
			reg_mult <= reg_dd2 * reg_sub;
		end
	end
endmodule