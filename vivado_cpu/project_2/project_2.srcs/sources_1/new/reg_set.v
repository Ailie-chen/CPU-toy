`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/23 16:40:49
// Design Name: 
// Module Name: reg_set
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

module reg_set(
    input                           i_clk         ,
    input           [3:0]           i_rA          ,
    input           [3:0]           i_rB          ,
    output          [63:0]          o_valA        ,
    output          [63:0]          o_valB        ,
    
    input           [3:0]           i_dstE        ,
    input           [3:0]           i_dstM        ,
    input           [63:0]          i_valE        ,
    input           [63:0]          i_valM        
    );
    
    reg         [63:0]          RAM[15:0]       ;
    assign  o_valA = &(i_rA)? 64'd0:RAM[i_rA];
    assign  o_valB = &(i_rB)? 64'd0:RAM[i_rB];
    
    
    
    always @(posedge i_clk) begin
        if(i_dstE == i_dstM) begin
            RAM[i_dstM] = &(i_dstM)? RAM[i_dstM]:i_valM;
        end
        else begin
            RAM[i_dstE] = &(i_dstE)? RAM[i_dstE]:i_valE;
            RAM[i_dstM] = &(i_dstM)? RAM[i_dstM]:i_valM;
        end
    end
endmodule
