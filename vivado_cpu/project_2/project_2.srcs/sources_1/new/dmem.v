`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/23 18:24:26
// Design Name: 
// Module Name: dmem
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


module dmem(
    input       [15:0]          i_mem_addr      ,
    input       [63:0]          i_mem_wr_data   ,
    input                       i_mem_en        ,
    input                       i_mem_wr        ,
    output  reg [63:0]          o_mem_rd_data
    );
    
    reg         [7:0]           RAM[65535:0];
    generate
    genvar i;
    for (i=0 ; i<8; i = i+1) begin
        always @(*) begin
            if(i_mem_en && i_mem_wr) begin
                RAM[i_mem_addr + 7-i] = i_mem_wr_data[(i+1)*8-1:i*8];
            end
            else if(i_mem_en && (~i_mem_wr)) begin               
                o_mem_rd_data[(i+1)*8-1:i*8] = RAM[i_mem_addr + 7 -i];
            end
        end
     end
    endgenerate
    
    
endmodule
