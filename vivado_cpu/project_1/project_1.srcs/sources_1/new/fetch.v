`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/19 18:43:45
// Design Name: 
// Module Name: fetch
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


module fetch(
    input                               i_clk           ,
    input                               i_rst_n         ,

    input           [15:0]              i_pc            ,
    output          [3:0]               o_icode         ,
    output          [3:0]               o_ifun          ,
    output          [3:0]               o_rA            ,
    output          [3:0]               o_rB            ,
    output  reg     [63:0]              o_valC          ,
    output  reg                         o_need_valC     ,
    output  reg                         o_need_rigids   ,
    output  reg                         o_instr_valid   ,
    output          [15:0]              o_valP
    );
    
    wire        [79:0]                  instr             ;
    reg        [15:0]                   pc_r              ;

    
    assign  o_icode = instr[79:76];
    assign  o_ifun  = instr[75:72];
    assign  o_rA    = o_need_rigids?instr[71:68]:4'hf;
    assign  o_rB    = o_need_rigids?instr[67:64]:4'hf;
    
    always @(posedge i_clk or negedge i_rst_n) begin
        if(!i_rst_n) begin
            pc_r <= 16'd0;
        end
        else begin
            pc_r <= i_pc;
        end
    end
    
    imem u_imem(
        .i_pc                           (pc_r           ),
        .o_instr                        (instr          )
    );
    always @(*) begin
        case(o_icode)
            4'h0,
            4'h1,
            4'h7,
            4'h8,
            4'h9:begin
                o_need_rigids = 1'b0;
            end
            default: begin
                o_need_rigids = 1'b1;
            end
        endcase
    end
    
    always @(*) begin
        case({o_icode,o_ifun}) 
            8'h30,
            8'h40,
            8'h50,
            8'h70,
            8'h71,
            8'h72,
            8'h73,
            8'h74,
            8'h75,
            8'h76,
            8'h80:begin
                o_need_valC = 1'b1;
            end
            default:begin
                o_need_valC  = 1'b0;
            end
        endcase
    end
    
    always @(*) begin
        case({o_icode,o_ifun})
            8'h00,
            8'h10,
            8'h20,
            8'h21,
            8'h22,
            8'h23,
            8'h24,
            8'h25,
            8'h26,
            8'h30,
            8'h40,
            8'h50,
            8'h60,
            8'h61,
            8'h62,
            8'h63,
            8'h70,
            8'h71,
            8'h72,
            8'h73,
            8'h74,
            8'h75,
            8'h76,
            8'h80,
            8'h90,
            8'ha0,
            8'hb0:begin
                o_instr_valid = 1'b1;
            end
            default:begin
                o_instr_valid = 1'b0;
            end
        endcase
    end
    
    always @(*) begin
        if(o_need_valC) begin
            if(o_icode == 4'h7 || o_icode == 4'h8) begin
                o_valC = instr[71:8];
            end
            else begin
                o_valC = instr[63:0];
            end
        end
        else begin
            o_valC = 64'd0;
        end
    end
    
    addpc u_addpc(
        .i_pc               (pc_r           ),         
        .i_need_valC        (o_need_valC    ),
        .i_need_rigids      (o_need_rigids  ),
        .o_valP             (o_valP         )
    );

endmodule