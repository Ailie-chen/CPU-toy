`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/19 11:51:40
// Design Name: 
// Module Name: addpc
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module addpc(
    input           [15:0]                  i_pc,
    input                                   i_need_valC,
    input                                   i_need_rigids,
    output  reg        [15:0]               o_valP   
);

    always @(*) begin
        o_valP = i_pc + 16'h1 + i_need_valC*16'h8 + i_need_rigids;
    end
    
endmodule