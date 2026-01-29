`timescale 1ns/10ps
module tb;
	reg [31:0] in_a, in_b;
	wire [63:0] out_res;
	reg clk, rst;
	reg [63:0] expected[$], actual[$];
	
	pipeline_alu dut(
		clk, in_a, in_b, out_res
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
		rst = 1;
		@(posedge clk);
		@(posedge clk);
		rst = 0;
		@(posedge clk);
		for (i=0; i<256; i=i+1) begin
			//@(posedge clk);
			in_a = $random;
			in_b = $random;
			#0.011 $display("in_a = %d; in_b = %d; out_res = %d;", in_a, in_b, out_res);
			expected.push_front(in_a*in_b);
			@(posedge clk);
		end
		while (actual.size()>0)
			$display("Expected = %d; Actual = %d", expected.pop_back(), actual.pop_back());
		$finish();
	end
endmodule
