`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/23 17:31:21
// Design Name: 
// Module Name: execute
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


module execute(
    input                   i_clk           ,

    input       [1:0]       i_E_stat        ,
    input       [3:0]       i_E_icode       ,
    input       [3:0]       i_E_ifun        ,
    input       [63:0]      i_E_valC        ,
    input       [63:0]      i_E_valA        ,
    input       [63:0]      i_E_valB        ,
    input       [3:0]       i_E_dstE        ,
    input       [3:0]       i_E_dstM        ,
    
    output reg  [1:0]       o_M_stat        ,
    output reg  [3:0]       o_M_icode       ,
    output reg              o_M_Cnd         ,
    output reg  [63:0]      o_M_valE        ,
    output reg  [63:0]      o_M_valA        ,
    output reg  [3:0]       o_M_dstE        ,
    output reg  [3:0]       o_M_dstM        ,
    
    input       [1:0]       i_W_stat        ,
    input       [1:0]       i_m_stat        ,
    output reg  [3:0]       o_e_dstE        ,
    output reg  [63:0]      o_e_valE        ,
    
    input                   i_M_bubble      ,
    output reg              o_e_Cnd             
    );
    
    reg             [63:0]           ALUA           ;
    reg             [63:0]           ALUB           ; 
    reg                              need_alu       ;
    
    wire                            set_cc          ;
    reg                              ZF             ;
    reg                              SF             ;
    reg                              OF             ;
    assign  set_cc = ((i_E_icode == 4'h6)&&(i_m_stat == 2'b11)&&(i_W_stat == 2'b11));
    
    always @(*) begin
        case({i_E_icode,i_E_ifun}) 
            8'h20,
            8'h60,
            8'h61,
            8'h62,
            8'h63 :begin
                ALUA = i_E_valA;
            end
            8'h30,
            8'h40,
            8'h50:begin
                ALUA = i_E_valC;
            end
            8'h80,
            8'ha0:begin
                ALUA = 64'hFFFFFFFFFFFFFFF8;
            end
            8'h90,
            8'hb0:begin
                ALUA = 64'd8;
            end
            default:begin
                ALUA = 64'd0;
            end
        endcase
    end
    
    always @(*) begin
        case({i_E_icode,i_E_ifun})
            8'h40,
            8'h50,
            8'h60,
            8'h61,
            8'h62,
            8'h63,
            8'h80,
            8'h90,
            8'ha0,
            8'hb0:begin
                ALUB = i_E_valB;
            end
            default:begin
                ALUB = 64'd0;
            end
        endcase
    end
    
    always @(*)begin
        case({i_E_icode,i_E_ifun})
            8'h00,
            8'h10,
            8'h70,
            8'h71,
            8'h72,
            8'h73,
            8'h74,
            8'h75,
            8'h76:begin
                need_alu = 1'b0;
            end
            default:begin
                need_alu = 1'b1;
            end
        endcase
    end
    
    always @(*) begin
        case({i_E_icode,i_E_ifun}) 
            8'h60:begin
                o_e_valE = ALUB + ALUA;
            end
            8'h61:begin
                o_e_valE = ALUB - ALUA;
            end
            8'h62:begin
                o_e_valE = ALUB&ALUA;
            end
            8'h63:begin
                o_e_valE = ALUB^ALUA;
            end
            default:begin
                o_e_valE = need_alu? ALUB+ALUA:o_e_valE;
            end
        endcase
    end
    
    always @(posedge i_clk) begin
        case({i_E_icode,i_E_ifun}) 
            8'h60:begin
                o_M_valE <= ALUB + ALUA;
            end
            8'h61:begin
                o_M_valE <= ALUB - ALUA;
            end
            8'h62:begin
                o_M_valE <= ALUB&ALUA;
            end
            8'h63:begin
                o_M_valE <= ALUB^ALUA;
            end
            default:begin
                o_M_valE <= need_alu? ALUB+ALUA:o_e_valE;
            end
        endcase
    end
   
    always @(posedge i_clk) begin
        if(i_M_bubble) begin
            o_M_icode <= 4'h0;
        end
        else begin
            o_M_icode <= i_E_icode;
        end
    end
    
    always @(posedge i_clk) begin
        o_M_stat <= i_E_stat;
    end
    
    always @(posedge i_clk) begin
        o_M_valA <= i_E_valA;
    end
    
    always @(posedge i_clk) begin
        o_M_dstM <= i_E_dstM;
    end
    
    always @(posedge i_clk) begin
        if(need_alu && set_cc) begin
            ZF <= !(|(o_e_valE));
        end
        else begin
            ZF <= ZF;
        end
    end
    
     always @(posedge i_clk) begin
        if(need_alu && set_cc) begin
            SF <= (o_e_valE[63] == 1'b1);
        end
        else begin
            SF <= SF;
        end
    end
    
     always @(posedge i_clk) begin
        if(need_alu && set_cc) begin
            if(i_E_ifun == 4'h0) begin
                OF <= (ALUA[63] == ALUB[63])&& ((o_e_valE[63] == 1'b1)!= (ALUA[63]==1));
            end
            else if(i_E_ifun == 4'h1) begin
                OF <= !((ALUA < ALUB) != o_e_valE[63]);
            end
        end
        else begin
            OF <= OF;
        end
    end
    
    always @(*) begin
        case({i_E_icode,i_E_ifun})
            8'h71:begin
                o_e_Cnd = (SF^OF)|ZF;
            end
            8'h72:begin
                o_e_Cnd = SF^OF;
            end
            8'h73:begin
                o_e_Cnd = ZF;
            end
            8'h74:begin
                o_e_Cnd = ~ZF;
            end
            8'h75:begin
                o_e_Cnd = ~(SF^OF);
            end
            8'h76:begin
                o_e_Cnd = (~(SF^OF))&(~ZF);
            end
            8'h70:begin
                o_e_Cnd = 1'b1;
            end
            default:begin
                o_e_Cnd = 1'b0;
            end
        endcase
    end
    
    always @(posedge i_clk) begin
        case({i_E_icode,i_E_ifun})
            8'h71:begin
                o_M_Cnd <= (SF^OF)|ZF;
            end
            8'h72:begin
                o_M_Cnd <= SF^OF;
            end
            8'h73:begin
                o_M_Cnd <= ZF;
            end
            8'h74:begin
                o_M_Cnd <= ~ZF;
            end
            8'h75:begin
                o_M_Cnd <= ~(SF^OF);
            end
            8'h76:begin
                o_M_Cnd <= (~(SF^OF))&(~ZF);
            end
            8'h70:begin
                o_M_Cnd <= 1'b1;
            end
            default:begin
                o_M_Cnd <= 1'b0;
            end
        endcase
    end
    
    always @(*) begin
        if((!o_e_Cnd)&&(set_cc)&&(i_E_icode == 4'h2)) begin
            o_e_dstE = 4'hf;
        end
        else begin         
            o_e_dstE = i_E_dstE;
        end
    end
    
    always @(posedge i_clk) begin
        if((!o_e_Cnd)&&(set_cc)&&(i_E_icode == 4'h2)) begin
            o_M_dstE <= 4'hf;
        end
        else begin        
            o_M_dstE <= i_E_dstE;
        end
    end
    
endmodule
