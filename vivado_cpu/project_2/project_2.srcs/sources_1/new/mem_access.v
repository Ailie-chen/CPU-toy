`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/23 18:25:11
// Design Name: 
// Module Name: mem_access
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


module mem_access(
    input                       i_clk           ,
    
    input           [1:0]       i_M_stat        ,
    input           [3:0]       i_M_icode       ,
    input           [63:0]      i_M_valE        ,
    input           [63:0]      i_M_valA        ,
    input           [3:0]       i_M_dstE        ,
    input           [3:0]       i_M_dstM        ,
    
    output  reg    [63:0]       o_W_valE        ,
    output  reg     [63:0]      o_W_valM        ,
    output  reg     [3:0]       o_W_dstE        ,
    output  reg     [3:0]       o_W_dstM        ,
    output  reg     [1:0]       o_W_stat        ,
    output  reg     [3:0]       o_W_icode       ,
    
    output          [63:0]      o_m_valM        ,
    input                       i_W_stall       ,
    output  reg     [1:0]       o_m_stat        
    );
    
    reg         [15:0]          mem_addr    ;
    
    reg                         mem_en      ;//enable memory
    reg                         mem_wr      ;//1:write 0:read
    
    always @(*) begin
        case(i_M_icode) 
            4'h4,
            4'h5,
            4'h8,
            4'ha,
            4'h9,
            4'hb:begin
                mem_en = 1'b1;
            end
            default:begin
                mem_en = 1'b0;
            end
        endcase
    end
    
   always @(*) begin
        case(i_M_icode) 
            4'h4,
            4'h8,
            4'ha:begin
                mem_wr = 1'b1;
            end
            4'h5,
            4'h9,
            4'hb:begin
                mem_wr = 1'b0;
            end
            default:begin
                mem_wr = 1'b0;
            end
        endcase
    end 
    
    always @(*) begin
        case(i_M_icode) 
            4'h4,
            4'h5,
            4'h8,
            4'ha:begin
                mem_addr = i_M_valE;
            end
            4'h9,
            4'hb:begin
                mem_addr = i_M_valA;
            end
        endcase
    end
    
    dmem u_dmem(
        .i_mem_addr     (mem_addr[15:0] ),
        .i_mem_wr_data  (i_M_valA       ),
        .i_mem_en       (mem_en         ),
        .i_mem_wr       (mem_wr         ),
        .o_mem_rd_data  (o_m_valM       )
    );
    
    always @(posedge i_clk) begin
        if((mem_addr[63]==1'b1)||(mem_addr > 64'd65536)) begin
            o_W_stat <= 2'b00;
        end
        else begin
            o_W_stat <= i_M_stat;
        end
    end
    
    always @(*) begin
        if((mem_addr[63]==1'b1)||(mem_addr > 64'd65536)) begin
            o_m_stat = 2'b00;
        end
        else begin
            o_m_stat = i_M_stat;
        end
    end
    
    always @(posedge i_clk) begin
        if(i_W_stall) begin
            o_W_valE <=o_W_valE ;
        end
        else begin
            o_W_valE <= i_M_valE;
        end
    end
    
    always @(posedge i_clk) begin
        if(i_W_stall) begin
            o_W_valM <=o_W_valM ;
        end
        else begin
            o_W_valM <= o_m_valM;
        end
    end
    
    always @(posedge i_clk) begin
        if(i_W_stall) begin
            o_W_dstE <=o_W_dstE ;
        end
        else begin
            o_W_dstE <= i_M_dstE;
        end
    end
    
    always @(posedge i_clk) begin
        if(i_W_stall) begin
            o_W_dstM <=o_W_dstM ;
        end
        else begin
            o_W_dstM <= i_M_dstM;
        end
    end
    
    always @(posedge i_clk) begin
        o_W_icode <= i_M_icode;
    end
endmodule
