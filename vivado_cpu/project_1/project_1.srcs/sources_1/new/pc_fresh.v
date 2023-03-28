`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/21 09:43:51
// Design Name: 
// Module Name: pc_fresh
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


module pc_fresh(
    input       [3:0]       i_icode     ,
    input       [3:0]       i_ifun      ,
    input       [63:0]      i_valC      ,
    input       [63:0]      i_valM      ,
    input                   i_cnd       ,
    input       [15:0]      i_valP      ,
    output reg  [15:0]      o_next_pc   
    );
    wire        [7:0]   instr;
    assign  instr = {i_icode,i_ifun};
    //always @(i_icode or i_ifun)begin
    always @(*)begin
        if((instr == 8'h80)||((i_icode == 4'h7) && (i_cnd))) begin
            o_next_pc = i_valC;
        end
        else if(instr == 8'h90) begin
            o_next_pc = i_valM;
        end
        else begin
            o_next_pc = i_valP;
        end
    end
endmodule
