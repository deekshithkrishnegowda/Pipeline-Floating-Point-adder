// Code your design here
/*********************** Arithmetic Floating Point Adder (without Pipeline)***********************/

module FP_adder (final_sum_80, input_1_80, input_2_80, clock_80);

input [15:0] input_1_80, input_2_80;		//16 bit inputs
input clock_80;					            //clock input
output reg [15:0] final_sum_80;			    //16 bit final result

reg sign_1_80, sign_2_80;			        //registers to store sign bits
reg [4:0] exponent_1_80, exponent_2_80;		//registers to store exponent bits
reg [9:0] mantissa_1_80, mantissa_2_80;	    //registers to store mantissa bits
reg [15:0] result_80;				        //registers to store end result

reg [4:0]exponent_max_80;			        //registers to store final exponent
reg [10:0] mantissa_1_11_80, mantissa_2_11_80;	//registers to store mantissa appended with 1 or 0
reg sign_80;					            //registers to store final sign
reg [11:0] sum_80;				            //registers to store final sum (with carry)

integer i_80;					            //for loop index integer

always @ (*) begin

	//to extract 1 bit sign from 32 bit input
	sign_1_80 = input_1_80[15];
	sign_2_80 = input_2_80[15];

	//to extract 8 bit exponent from 32 bit input
	exponent_1_80 = input_1_80[14:10];
	exponent_2_80 = input_2_80[14:10];

	//to extract 23 bit mantissa from 32 bit input
	mantissa_1_80 = input_1_80[9:0];
	mantissa_2_80 = input_2_80[9:0];

	//to assign result to final_sum
	final_sum_80 [15] = sign_80;
	final_sum_80[14:10] = exponent_max_80;
	final_sum_80 [9:0] = sum_80;

end


always @(*) begin

		// to compare exponents
		// if exponent1 is greater than or equal to exponent2
		if ( exponent_1_80 >= exponent_2_80) begin

			//choose exponent1
			exponent_max_80 = exponent_1_80;

			if (mantissa_2_80 == 10'b0000_0000_00) begin
				//append mantissa1 with 0 
				mantissa_2_11_80 = {1'b0,mantissa_2_80};
			end else begin
				//append mantissa1 with 1 and shift left by the amount of difference in exponents
				mantissa_2_11_80 = {1'b1,mantissa_2_80} >> (exponent_1_80 - exponent_2_80);
			end
			if (mantissa_2_80 == 10'b0000_0000_00) begin
				//append mantissa2 with 0
				mantissa_1_11_80 = {1'b0,mantissa_1_80};
			end else begin
				//append mantissa2 with 1
				mantissa_1_11_80 = {1'b1,mantissa_1_80};
			end

		end else begin
			// if exponent2 is greater than exponent1
			//choose exponent2
			exponent_max_80 = exponent_2_80;
			
			if (mantissa_1_80 == 10'b0000_0000_0000) begin
				//append mantissa1 with 0
				mantissa_1_11_80 = {1'b0,mantissa_1_80};
			end else begin
				//append mantissa1 with 1 and shift left by the amount of difference in exponents
				mantissa_1_11_80 = {1'b1,mantissa_1_80} >> (exponent_2_80 - exponent_1_80);
			end
			if (mantissa_2_80 == 10'b0000_0000_00) begin
				//append mantissa2 with 0
				mantissa_2_11_80 = {1'b0,mantissa_2_80};
			end else begin
				//append mantissa2 with 1
				mantissa_2_11_80 = {1'b1,mantissa_2_80};
			end
		end

		//if both the numbers have same sign,
		if (sign_1_80 == sign_2_80) begin
			
			//retain the sign
			sign_80 = sign_1_80;
			//add the two mantissa
			sum_80 = mantissa_1_11_80 + mantissa_2_11_80;

		end else begin
			
			//if both the numbers have different sign,
			if (mantissa_1_11_80 > mantissa_2_11_80) begin

				//if mantissa1 > mantissa2, sign of the bigger number (mantissa 1)	
				sign_80 = sign_1_80;
				// add mantissa1 and 2's compliment of mantissa2
				sum_80 = mantissa_1_11_80 + ((~mantissa_2_11_80) + 1'b1);

			end else begin

				//if mantissa2 > mantissa1, sign of the bigger number (mantissa 2)
				sign_80 = sign_2_80;
				// add mantissa2 and 2's compliment of mantissa1
				sum_80 = mantissa_2_11_80 + ((~mantissa_1_11_80) + 1'b1);

			end
		end
		
		//overflow occurs if carry is 1
		if(sign_1_80 == sign_2_80 && sum_80[11] == 1'b1) begin

			//shift mantissa sum to right by 1
			sum_80 = sum_80 >>1'b1;
			//and increment the exponent by 1
			exponent_max_80 = exponent_max_80 + 1'b1;

		end else begin
		
			//to normalize the mantissa of sum by shifting it left.
			for (i_80=0; ((i_80<=11) && (sum_80[10]) == 1'b0 && (sum_80 != 12'b0)); i_80=i_80+1) begin
				sum_80 = sum_80 << 1'b1;
				exponent_max_80 = exponent_max_80 - 1'b1;
			end

		end
end

endmodule
			
