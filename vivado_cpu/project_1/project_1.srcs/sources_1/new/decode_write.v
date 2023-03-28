`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/19 22:17:22
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
    input                           i_clk       ,
    input           [3:0]           i_icode     ,
    input           [3:0]           i_ifun      ,
    input           [3:0]           i_rA        ,
    input           [3:0]           i_rB        ,
    output          [63:0]          o_valA      ,
    output          [63:0]          o_valB      ,
    
    input           [63:0]          i_valE      ,
    input           [63:0]          i_valM
 );
    reg         [3:0]           srcA        ;
    reg         [3:0]           srcB        ;
    
    reg         [3:0]           dstE        ;
    reg         [3:0]           dstM        ;
    
    always@(*) begin
        case({i_icode,i_ifun})
            8'h20,
            8'h40,
            8'ha0,
            8'h60,
            8'h61,
            8'h62,
            8'h63 :begin
                srcA = i_rA;
            end
            8'h90,
            8'hb0:begin
                srcA = 4'h4;
            end
            default:begin
                srcA = 4'hf;                                                             
            end
        endcase
    end
    
    always@(*) begin
        case({i_icode,i_ifun})
            8'h40,
            8'h50,
            8'h60,
            8'h61,
            8'h62,
            8'h63 :begin
                srcB = i_rB;
            end
            8'h80,
            8'h90,
            8'ha0,
            8'hb0:begin
                srcB = 4'h4;
            end
            default:begin
                srcB = 4'hf;                                                             
            end
        endcase
    end
    
    always @(*) begin
        case({i_icode,i_ifun})
            8'h20,
            8'h30,
            8'h60,
            8'h61,
            8'h62,
            8'h63 :begin
                dstE = i_rB;
            end 
            8'h80,
            8'h90,
            8'ha0,
            8'hb0:begin
                dstE = 4'h4;
            end
            default:begin
                dstE = 4'hf;
            end                                                                                          
        endcase
    end
    
    always @(*) begin
        case({i_icode,i_ifun}) 
            8'h50,
            8'hb0:begin
                dstM = i_rA;
            end
            default:begin
                dstM = 4'hf;
            end
        endcase
    end
    
    reg_set ureg_set
    (
        .i_clk              (i_clk      ),
        .i_rA               (srcA       ),
        .i_rB               (srcB       ),
        .o_valA             (o_valA     ),
        .o_valB             (o_valB     ),
        .i_dstE             (dstE       ),
        .i_dstM             (dstM       ),
        .i_valE             (i_valE     ),
        .i_valM             (i_valM     )
    );
endmodule
