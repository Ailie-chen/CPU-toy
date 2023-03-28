`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/23 16:06:41
// Design Name: 
// Module Name: decode_write
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


module decode_write(
    input                       i_clk           ,

    input           [1:0]       i_D_stat        ,
    input           [3:0]       i_D_icode       ,
    input           [3:0]       i_D_ifun        ,
    input           [3:0]       i_D_rA          ,
    input           [3:0]       i_D_rB          ,
    input           [63:0]      i_D_valC        ,
    input           [63:0]      i_D_valP        ,
    
    output  reg     [1:0]       o_E_stat        ,
    output  reg     [3:0]       o_E_icode       ,
    output  reg     [3:0]       o_E_ifun        ,
    output  reg     [63:0]      o_E_valC        ,
    output  reg     [63:0]      o_E_valA        ,
    output  reg     [63:0]      o_E_valB        ,
    output  reg     [3:0]       o_E_dstE        ,
    output  reg     [3:0]       o_E_dstM        ,
    output  reg     [3:0]       o_E_srcA        ,
    output  reg     [3:0]       o_E_srcB        ,
    
    input           [3:0]       i_e_dstE        ,
    input           [63:0]      i_e_valE        ,
    input           [3:0]       i_M_dstE        ,
    input           [63:0]      i_M_valE        ,
    input           [3:0]       i_M_dstM        ,
    input           [63:0]      i_m_valM        ,
    input           [3:0]       i_W_dstM        ,
    input           [63:0]      i_W_valM        ,
    input           [3:0]       i_W_dstE        ,
    input           [63:0]      i_W_valE        ,
    
    input                       i_E_bubble      ,
    
    output  reg    [3:0]        o_d_srcA        ,
    output  reg    [3:0]        o_d_srcB         
    );
    
    wire        [63:0]          d_rvalA     ;
    wire        [63:0]          d_rvalB     ;
    
     always@(*) begin
        case({i_D_icode,i_D_ifun})
            8'h20,
            8'h40,
            8'ha0,
            8'h60,
            8'h61,
            8'h62,
            8'h63 :begin
                    o_d_srcA = i_D_rA;
            end
            8'h90,
            8'hb0:begin
                    o_d_srcA = 4'h4;
            end
            default:begin
                o_d_srcA = 4'hf;                                                             
            end
        endcase
    end
    
    always@(*) begin
        case({i_D_icode,i_D_ifun})
            8'h40,
            8'h50,
            8'h60,
            8'h61,
            8'h62,
            8'h63 :begin
                    o_d_srcB = i_D_rB;
            end
            8'h80,
            8'h90,
            8'ha0,
            8'hb0:begin
                    o_d_srcB = 4'h4;
            end
            default:begin
                o_d_srcB = 4'hf;                                                             
            end
        endcase
    end
    
    always @(posedge i_clk) begin
        if(i_E_bubble) begin
            o_E_dstE <= 4'hf;
        end
        else begin
        case({i_D_icode,i_D_ifun})
            8'h20,
            8'h30,
            8'h60,
            8'h61,
            8'h62,
            8'h63 :begin
                o_E_dstE <= i_D_rB;
            end 
            8'h80,
            8'h90,
            8'ha0,
            8'hb0:begin
                o_E_dstE <= 4'h4;
            end
            default:begin
                o_E_dstE <= 4'hf;
            end                                                                                          
        endcase
        end
    end
    
    always @(posedge i_clk) begin
        if(i_E_bubble) begin
            o_E_dstM <= 4'hf;
        end
        else begin
        case({i_D_icode,i_D_ifun}) 
            8'h50,
            8'hb0:begin
                o_E_dstM <= i_D_rA;
            end
            default:begin
                o_E_dstM <= 4'hf;
            end
        endcase
        end
    end
    
    
     reg_set ureg_set
    (
        .i_clk              (i_clk      ),
        .i_rA               (o_d_srcA       ),
        .i_rB               (o_d_srcB       ),
        .o_valA             (d_rvalA    ),
        .o_valB             (d_rvalB    ),
        .i_dstE             (i_W_dstE   ),
        .i_dstM             (i_W_dstM   ),
        .i_valE             (i_W_valE   ),
        .i_valM             (i_W_valM   )
    );
    
    always @(posedge i_clk) begin
        if((i_D_icode == 4'h7)||(i_D_icode == 4'h8)) begin
            o_E_valA <= i_D_valP;
        end
        else if(o_d_srcA == 4'hf) begin
            o_E_valA <= d_rvalA;
        end
        else begin
            case(o_d_srcA) 
                i_e_dstE:begin
                    o_E_valA <= i_e_valE;
                end
                i_M_dstM:begin
                    o_E_valA <= i_m_valM;
                end
                i_M_dstE:begin
                    o_E_valA <= i_M_valE;
                end
                i_W_dstM:begin
                    o_E_valA <= i_W_valM;
                end
                i_W_dstE:begin
                    o_E_valA <= i_W_valE;
                end
                default:begin
                    o_E_valA <= d_rvalA;
                end
            endcase
        end
    end
    
    always @(posedge i_clk) begin
        if(o_d_srcB == 4'hf) begin
            o_E_valB <= d_rvalB;
        end
        case(o_d_srcB)
            i_e_dstE:begin
                o_E_valB <= i_e_valE;
            end
            i_M_dstM:begin
                o_E_valB <= i_m_valM;
            end
            i_M_dstE:begin
                o_E_valB <= i_M_valE;
            end
            i_W_dstM:begin
                o_E_valB <= i_W_valM;
            end
            i_W_dstE:begin
                 o_E_valB <= i_W_valE;
            end
            default:begin
                 o_E_valB <= d_rvalB;
            end
        endcase
    end
    
    always @(posedge i_clk) begin
        o_E_stat <= i_D_stat;
    end
    
    always @(posedge i_clk) begin
        if(i_E_bubble) begin
            o_E_icode <= 4'h0;
        end
        else begin
            o_E_icode <= i_D_icode;
        end
    end
    
    always @(posedge i_clk) begin
        if(i_E_bubble) begin
            o_E_ifun <= 4'h0;
        end
        else begin
            o_E_ifun <= i_D_ifun;
        end
    end
    
    always @(posedge i_clk) begin
        o_E_valC <= i_D_valC;
    end
    
     always@(posedge i_clk) begin
        if(i_E_bubble) begin
            o_E_srcA <= 4'hf;  
        end
        else begin
        case({i_D_icode,i_D_ifun})
            8'h20,
            8'h40,
            8'ha0,
            8'h60,
            8'h61,
            8'h62,
            8'h63 :begin
                o_E_srcA <= i_D_rA;
            end
            8'h90,
            8'hb0:begin
                o_E_srcA <= 4'h4;
            end
            default:begin
                o_E_srcA <= 4'hf;                                                             
            end
        endcase
        end
    end
    
    always@(posedge i_clk) begin
        if(i_E_bubble) begin
            o_E_srcB <= 4'hf;  
        end
        else begin
        case({i_D_icode,i_D_ifun})
            8'h40,
            8'h50,
            8'h60,
            8'h61,
            8'h62,
            8'h63 :begin
                o_E_srcB <= i_D_rB;
            end
            8'h80,
            8'h90,
            8'ha0,
            8'hb0:begin
                o_E_srcB <= 4'h4;
            end
            default:begin
                o_E_srcB <= 4'hf;                                                             
            end
        endcase
        end
    end
    
endmodule
