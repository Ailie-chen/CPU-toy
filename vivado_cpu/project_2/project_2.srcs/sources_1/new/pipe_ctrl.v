`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/24 10:51:04
// Design Name: 
// Module Name: pipe_ctrl
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


module pipe_ctrl(
    input           [3:0]           i_E_icode       ,
    input           [3:0]           i_E_dstM        ,
    input           [3:0]           i_D_icode       ,
    input           [3:0]           i_M_icode       ,
    input                           i_e_Cnd         ,
    input           [3:0]           i_d_srcA        ,
    input           [3:0]           i_d_srcB        ,
    input           [1:0]           i_m_stat        ,
    input           [1:0]           i_W_stat        ,
    
    output  reg                     o_F_stall       ,
    output  reg                     o_D_stall       ,
    output  reg                     o_D_bubble      ,
    output  reg                     o_E_bubble      ,
    output  reg                     o_M_bubble      ,
    output  reg                     o_W_stall       

    );
    
    always @(*) begin
        if((i_E_icode == 4'h5 ||i_E_icode == 4'hb)&&((i_E_dstM == i_d_srcA)||(i_E_dstM == i_d_srcB))) begin
            o_F_stall = 1'b1;
        end
        else if(i_D_icode == 4'h9 || i_E_icode == 4'h9 ||i_M_icode == 4'h9 ) begin
                o_F_stall = 1'b1;
        end
        else begin
            o_F_stall = 1'b0;
        end
    end
    
    always @(*) begin
        if((i_E_icode == 4'h5 ||i_E_icode == 4'hb)&&((i_E_dstM == i_d_srcA)||(i_E_dstM == i_d_srcB))) begin
            o_D_stall = 1'b1;
        end
        else begin
            o_D_stall = 1'b0;
        end
    end
    
    always @(*) begin 
        if((i_E_icode == 4'h7) && (!i_e_Cnd))begin
            o_D_bubble = 1'b1;
        end   
        else if((!((i_E_icode == 4'h5 ||i_E_icode == 4'hb)&&((i_E_dstM == i_d_srcA)||(i_E_dstM == i_d_srcB))))&&(i_D_icode == 4'h9 || i_E_icode == 4'h9 ||i_M_icode == 4'h9 )) begin
            o_D_bubble = 1'b1;
        end
        else begin
            o_D_bubble = 1'b0;
        end     
    end
    
    always @(*) begin
        if((i_E_icode == 4'h7) && (!i_e_Cnd))begin
            o_E_bubble = 1'b1;
        end
        else if(((i_E_icode == 4'h5) ||(i_E_icode == 4'hb))&&((i_E_dstM == i_d_srcA)||(i_E_dstM == i_d_srcB))) begin
            o_E_bubble = 1'b1;
        end
        else begin
            o_E_bubble = 1'b0;
        end
    end
    
    always @(*) begin
        if(!(i_m_stat == 2'b11 && i_W_stat == 2'b11)) begin
            o_M_bubble = 1'b1;
        end
        else begin
            o_M_bubble = 1'b0;
        end
    end
    
    always @(*) begin
        if(!(i_W_stat == 2'b11)) begin
            o_W_stall = 1'b1;
        end
        else begin
            o_W_stall = 1'b0;
        end
    end
endmodule
