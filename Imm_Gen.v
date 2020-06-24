/***************************************************
Student Name: 
Student ID: 
***************************************************/

`timescale 1ns/1ps

module Imm_Gen(
	input  [31:0] instr_i,
	output [31:0] Imm_Gen_o
	);

reg   [31:0]		reg1;
wire	[7-1:0]		opcode;
wire 	[3-1:0]		funct3;
/* Write your code HERE */
assign opcode = instr_i[6:0];
assign funct3 = instr_i[14:12];
assign Imm_Gen_o = reg1;

always@(*) begin
//$display("imm:",Imm_Gen_o);
	case(opcode)
		7'b0000011: begin
			reg1 = {{20{instr_i[31]}},instr_i[31:20]};
		end
		7'b0010011: begin
			reg1 = {{20{instr_i[31]}},instr_i[31:20]};
		end
		7'b0100011: begin
			reg1 = {{20{instr_i[31]}},instr_i[31:25],instr_i[11:7]};
		end
		7'b1100011: begin
			reg1 = {{20{instr_i[31]}},instr_i[31],instr_i[7],instr_i[30:25],instr_i[11:8]};
		end
		7'b1101111: begin
			reg1 = {{11{instr_i[31]}},instr_i[31],instr_i[19:12],instr_i[20],instr_i[30:21]};
		end
		default: 
			reg1 = 0;
	endcase
end		
endmodule