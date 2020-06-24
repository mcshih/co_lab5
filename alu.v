/***************************************************
Student Name:
Student ID:
***************************************************/
`timescale 1ns/1ps

module alu(
	input	       	rst_n,         // Reset                     (input)
	input				[31:0] src1,          // 32 bits source 1          (input)
	input				[31:0] src2,          // 32 bits source 2          (input)
	input 			[3:0] ALU_control,   // 4 bits ALU control input  (input)
	output  reg  	[31:0] result,        // 32 bits result            (output)
	output  reg    zero,          // 1 bit when the output is 0, zero must be set (output)
	output  reg    cout,          // 1 bit carry out           (output)
	output  reg    overflow       // 1 bit overflow            (output)
	);

/* Write your code HERE */
	always@(rst_n or ALU_control or src1 or src2) begin
		if(rst_n) begin
			case(ALU_control)
				4'b0000: begin						//add
					result = src1 + src2;
				end
				4'b0010: begin						//sub
					result = src1 - src2;
					//$display("%d=%d-%d", result, src1, src2);
				end
				4'b0011: begin						//and
					result = src1 & src2;
				end
				4'b0100: begin						//or
					result = src1 | src2;
				end
				4'b0101: begin						//xor
					result = src1 ^ src2;
				end
				4'b0110: begin						//slt
					result = (src1 < src2)?1 : 0;
				end
				4'b1000: begin						//beq
					zero = (src1 == src2)?1:0;
					//$display("%d=%d==%d", zero, src1, src2);
				end
				4'b1001: begin						//sll
					result = src1 << src2;
					//$display("%d=%d<<%d", result, src1, src2);
				end
				4'b1010: begin					//srl
					result = src1 >> src2;
					//$display("%d=%d>>%d", result, src1, src2);
				end
				4'b1011: begin					//sra
					result = src1 >>> src2;
					//$display("%d=%d>>>%d", result, src1, src2);
				end
				4'b1100: begin					//blt
					zero = (src1 < src2)? 1 : 0;
					//$display("%d=%d!=%d", zero, src1, src2);
				end
				4'b1101: begin					//bge
					zero = (src1 >= src2)? 1 : 0;
					//$display("%d=%d!=%d", zero, src1, src2);
				end
				4'b1111: begin					//bne
					zero = (src1 != src2)? 1 : 0;
					//$display("%d=%d!=%d", zero, src1, src2);
				end
				default:
					result = 0;
			endcase
		end
		else begin
			zero = 0;
			cout = 0;
			overflow = 0;
			result = 0;
		end
	end



endmodule
