/***************************************************
Student Name: 
Student ID: 
***************************************************/

`timescale 1ns/1ps

module ALU_Ctrl(
	input		[3:0]	instr,
	input		[1:0]	ALUOp,
	output reg	[3:0] ALU_Ctrl_o
	);
	
/* Write your code HERE */
always@(instr or ALUOp) begin
	//$display("%b %b\n", instr, ALUOp);
		case(ALUOp)
			2'b00: begin				// S type
				case(instr[2:0])		//sw
					3'b010:		begin
						ALU_Ctrl_o = 4'b0000;
					end
					default: begin
						ALU_Ctrl_o = ALU_Ctrl_o;
					end
				endcase
			end
			2'b01: begin				//B type
				case(instr[2:0])
					3'b000:		begin		//beq
						ALU_Ctrl_o = 4'b1000;
					end
					3'b001:		begin		//bne
						ALU_Ctrl_o = 4'b1111;
					end
					3'b100:		begin		//blt
						ALU_Ctrl_o = 4'b1100;
					end
					3'b101:		begin		//bge
						ALU_Ctrl_o = 4'b1101;
					end
					default: begin
						ALU_Ctrl_o = ALU_Ctrl_o;
					end
				endcase
			end
			2'b10: begin				//R type
				case(instr)
					4'b0000:		begin		//add
						ALU_Ctrl_o = 4'b0000;
					end
					4'b1000:		begin		//sub
						ALU_Ctrl_o = 4'b0010;	
					end
					4'b0111:		begin		//and
						ALU_Ctrl_o = 4'b0011;
					end
					4'b0110:		begin		//or
						ALU_Ctrl_o = 4'b0100;
					end
					4'b0100:		begin		//xor
						ALU_Ctrl_o = 4'b0101;
					end
					4'b0010:		begin		//slt
						ALU_Ctrl_o = 4'b0110;
					end
					4'b0001:		begin		//sll
						ALU_Ctrl_o = 4'b1001;
					end
					4'b1101:		begin		//sra
						ALU_Ctrl_o = 4'b1011;
					end
					default: begin
						ALU_Ctrl_o = ALU_Ctrl_o;
					end
				endcase
			end
			2'b11: begin				//I type
				case(instr[2:0])
					3'b000:		begin		//addi
						ALU_Ctrl_o = 4'b0000;
					end
					3'b111:		begin		//andi
						ALU_Ctrl_o = 4'b0011;
					end
					3'b110:		begin		//ori
						ALU_Ctrl_o = 4'b0100;
					end
					3'b010:		begin		//slti lw¤]¤@¼Ë
						ALU_Ctrl_o = 4'b0000;
					end
					3'b001:		begin		//slli
						ALU_Ctrl_o = 4'b1001;
					end
					3'b101:		begin		//srli
						ALU_Ctrl_o = 4'b1010;
					end
					3'b100:		begin		//xori
						ALU_Ctrl_o = 4'b0101;
					end
					default: begin
						ALU_Ctrl_o = ALU_Ctrl_o;
					end
				endcase
			end
			default:
				ALU_Ctrl_o = ALU_Ctrl_o;
		endcase
	end
 
endmodule