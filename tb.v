`timescale 1ns/10ps
module tb;
	reg signed [8:0] in_a, in_b, in_c, in_d;
	wire signed [19:0] out_res;
	reg clk, rst;
	reg signed [19:0] expected[$], actual[$];
	
	pipeline_alu dut(
		clk, rst, in_a, in_b, in_c, in_d, out_res
	);

	reg [3:0] count;
	always @(posedge clk or posedge rst) begin
		if (rst)
			count = 0;
		else if (count < 4)
				count = count + 1;
			else
				#0.011 actual.push_front(out_res);
	end
	
	initial begin
		clk = 0;
		forever 
			#(`PERIOD/2) clk = ~clk;
	end
	
	integer i;
	initial begin
		$dumpfile("out.vcd");
		$dumpvars(0, tb);
		in_a = 0;
		in_b = 0;
		in_c = 0;
		in_d = 0;
		rst = 1;
		@(posedge clk);
		@(posedge clk);
		rst = 0;
		@(posedge clk);
		for (i=0; i<256; i=i+1) begin
			//@(posedge clk);
			in_a = $random % 256;
			in_b = $random % 256;
			in_c = $random % 256;
			in_d = $random % 256;
			#0.011 $display("in_a = %d; in_b = %d; in_c = %d; in_d = %d; out_res = %d;", in_a, in_b, in_c, in_d, out_res);
			expected.push_front((in_a+in_b-in_c)*in_d);
			@(posedge clk);
		end
		while (actual.size()>0)
			$display("Expected = %d; Actual = %d", expected.pop_back(), actual.pop_back());
		$finish();
	end
endmodule
