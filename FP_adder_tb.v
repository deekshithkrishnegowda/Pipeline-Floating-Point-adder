// Code your testbench here
// or browse Examples
// Code your testbench here
// or browse Examples 
module FP_adder_tb();

reg [15:0] input_1_80, input_2_80;
reg clock_80;
wire [15:0] sum_80;

//module call
FP_adder DUT (sum_80, input_1_80, input_2_80, clock_80);

//to generate dump files
initial begin
	$dumpfile ("FP_adder.vcd");
	$dumpvars (0);
end

//generate clock
initial begin
	clock_80 = 0;
	forever begin
		#5 clock_80 = ~clock_80;
	end
end

//to provide inputs
initial begin
  $monitor ($time, "sum=%b", 
		sum_80);

	@(negedge clock_80); 
		input_1_80 = 16'b0_10101_1000100000; 
		input_2_80 = 16'b0_10110_0101001000;
	@(negedge clock_80); 
		input_1_80 = 16'b0_10101_1000110000; 
		input_2_80 = 16'b1_10101_0110010000;
	@(negedge clock_80); 
		input_1_80 = 16'b1_10100_0110100000; 
		input_2_80 = 16'b0_10101_0011110000;
	@(negedge clock_80); 
		input_1_80 = 16'b1_10111_0001101100; 
		input_2_80 = 16'b1_10101_0000100000;
	@(negedge clock_80); 
		input_1_80 = 16'b0_00000_0000000000; 
		input_2_80 = 16'b0_00000_0000000000;
	@(negedge clock_80); 
		input_1_80 = 16'b0_00000_0000000000; 
		input_2_80 = 16'b1_10101_1101010000;
	@(negedge clock_80); 
		input_1_80 = 16'b1_10101_1011100010; 
		input_2_80 = 16'b0_10101_1000111110;
	@(negedge clock_80); 
		input_1_80 = 16'b0_10101_1011101110; 
		input_2_80 = 16'b0_10101_1000110010;
  repeat (4) @(negedge clock_80);
	 $finish;

end

endmodule
