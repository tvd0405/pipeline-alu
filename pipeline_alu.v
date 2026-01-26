module pipeline_alu (
	input clk,
	input rst,
	input signed [8:0] a,
	input signed [8:0] b,
	output signed [19:0] out
);
	reg signed [8:0] reg_a;
	reg signed [8:0] reg_b; 
	reg signed [8:0] reg_ad;
	reg signed [8:0] reg_bd; 
	reg signed [9:0] reg_add;
	reg signed [9:0] reg_addd;
	reg signed [9:0] reg_sub; 
	reg signed [19:0] reg_mult;

	assign out = reg_mult;
	
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			reg_a <= 0;
			reg_b <= 0;
			reg_add <= 0;
			reg_sub <= 0;
			reg_mult <= 0;
		end else begin
			reg_a <= a;
			reg_b <= b;
			reg_ad <= reg_a;
			reg_bd <= reg_b;
			reg_add <= reg_a + reg_b;
			reg_addd <= reg_add;
			reg_sub <= reg_ad - reg_bd;				
			reg_mult <= reg_addd * reg_sub;
		end
	end
endmodule