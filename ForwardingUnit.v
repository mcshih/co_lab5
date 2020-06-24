`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:03:42 06/06/2020 
// Design Name: 
// Module Name:    ForwardingUnit 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ForwardingUnit(
    input [4:0] ID_RS1,
	 input [4:0] ID_RS2,
	 input [4:0] RS1,
    input [4:0] RS2,
    input [4:0] EX_MEM_regRd,
    input [4:0] MEM_WB_regRd,
	 input ID_EX_RegWrite,
    input EX_MEM_RegWrite,
    input MEM_WB_RegWrite,
    output reg [1:0] EX_ForwardingA,
    output reg [1:0] EX_ForwardingB,
    output reg ID_ForwardingA,
    output reg ID_ForwardingB
    );

always @(*)begin
	if((EX_MEM_RegWrite) && EX_MEM_regRd != 0 && (EX_MEM_regRd == RS1))
		EX_ForwardingA = 2'b10;
	else if((MEM_WB_RegWrite) && MEM_WB_regRd != 0 && (MEM_WB_regRd == RS1))
		EX_ForwardingA = 2'b01;
	else begin
		EX_ForwardingA = 2'b00;
	end
end
always @(*)begin
	if((EX_MEM_RegWrite) && EX_MEM_regRd != 0 && (EX_MEM_regRd == RS2))
		EX_ForwardingB = 2'b10;
	else if((MEM_WB_RegWrite) && MEM_WB_regRd != 0  && (MEM_WB_regRd == RS2))
		EX_ForwardingB = 2'b01;
	else begin
		EX_ForwardingB = 2'b00;
	end
end
always @(*)begin
	if(ID_EX_RegWrite && MEM_WB_regRd == ID_RS1)
		ID_ForwardingA = 1;
	else begin
		ID_ForwardingA = 0;
	end
end
always @(*)begin
	if(ID_EX_RegWrite && MEM_WB_regRd == ID_RS2)
		ID_ForwardingB = 1;
	else begin
		ID_ForwardingB = 0;
	end
end

endmodule
