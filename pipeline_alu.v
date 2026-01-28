module pipeline_alu (
	input clk,
	input rst,
	input [23:0] a,
	input [23:0] b,
	output [47:0] out
);
	reg [23:0] reg_a;
	reg [23:0] reg_b; 
	reg [23:0] mult[0:8];
	reg [47:0] mult_temp[0:1];
	reg [47:0] reg_mult;

	assign out = reg_mult;
	
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			reg_a <= 0;
			reg_b <= 0;
		end else begin
			reg_a <= a;
			reg_b <= b;
			mult[0] <= reg_a[7:0] * reg_b[7:0];
			mult[1] <= reg_a[7:0] * reg_b[15:8];
			mult[2] <= reg_a[7:0] * reg_b[23:16];
			mult[3] <= reg_a[15:8] * reg_b[7:0];
			mult[4] <= reg_a[15:8] * reg_b[15:8];
			mult[5] <= reg_a[15:8] * reg_b[23:16];
			mult[6] <= reg_a[23:16] * reg_b[7:0];
			mult[7] <= reg_a[23:16] * reg_b[15:8];
			mult[8] <= reg_a[23:16] * reg_b[23:16];
			mult_temp[0] <= {mult[8],32'b0} + {mult[7]+mult[5],24'b0} + mult[0];
			mult_temp[1] <= {mult[2]+mult[4]+mult[6],16'b0} + {mult[1]+mult[3],8'b0};
			reg_mult <= mult_temp[0] + mult_temp[1];
		end
	end
endmodule