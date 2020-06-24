`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:11:02 06/01/2020 
// Design Name: 
// Module Name:    Pipline 
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
 
module Pipline
#(
		parameter size = 0
)
(
		input clk_i,
		input rst_i,
		input [size-1:0] data_i,
		output reg [size-1:0] data_o
);

always@(posedge clk_i) begin
		if(rst_i == 0) begin
			data_o = 0;
		end
		else begin
		   data_o = data_i;
		end
end

endmodule
