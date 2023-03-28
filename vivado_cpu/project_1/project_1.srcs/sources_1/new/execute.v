`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/20 11:30:12
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
    input           [3:0]           i_icode         ,
    input           [3:0]           i_ifun          ,
    input           [63:0]          i_valA          ,
    input           [63:0]          i_valB          ,
    input           [63:0]          i_valC          ,
    
    output   reg                    o_Cnd           ,
    output   reg    [63:0]          o_valE            
    );
    
    reg             [63:0]           ALUA           ;
    reg             [63:0]           ALUB           ; 
    
    reg                              need_alu       ;
    wire                             set_cc         ;
    reg                              ZF             ;
    reg                              SF             ;
    reg                              OF             ;
    assign  set_cc = (i_icode == 4'h6);
    always @(*) begin
        case({i_icode,i_ifun}) 
            8'h20,
            8'h60,
            8'h61,
            8'h62,
            8'h63 :begin
                ALUA = i_valA;
            end
            8'h30,
            8'h40,
            8'h50:begin
                ALUA = i_valC;
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
        case({i_icode,i_ifun})
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
                ALUB = i_valB;
            end
            default:begin
                ALUB = 64'd0;
            end
        endcase
    end
    
    always @(*)begin
        case({i_icode,i_ifun})
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
        case({i_icode,i_ifun}) 
            8'h60:begin
                o_valE = ALUB + ALUA;
            end
            8'h61:begin
                o_valE = ALUB - ALUA;
            end
            8'h62:begin
                o_valE = ALUB&ALUA;
            end
            8'h63:begin
                o_valE = ALUB^ALUA;
            end
            default:begin
                o_valE = need_alu? ALUB+ALUA:o_valE;
            end
        endcase
    end
    
    always @(*) begin
        if(need_alu) begin
            ZF = !(|(o_valE));
        end
        else begin
            ZF = ZF;
        end
    end
    
     always @(*) begin
        if(need_alu) begin
            SF = (o_valE[63] == 1'b1);
        end
        else begin
            SF = SF;
        end
    end
    
     always @(*) begin
        if(need_alu) begin
            if(i_ifun == 4'h0) begin
                OF = (ALUA[63] == ALUB[63])&& ((o_valE[63] == 1'b1)!= (ALUA[63]==1));
            end
            else if(i_ifun == 4'h1) begin
                OF = (ALUA < ALUB) != o_valE[63];
            end
        end
        else begin
            OF = OF;
        end
    end
    
    always @(*) begin
        case({i_icode,i_ifun})
            8'h71:begin
                o_Cnd = (SF^OF)|ZF;
            end
            8'h72:begin
                o_Cnd = SF^OF;
            end
            8'h73:begin
                o_Cnd = ZF;
            end
            8'h74:begin
                o_Cnd = ~ZF;
            end
            8'h75:begin
                o_Cnd = ~(SF^OF);
            end
            8'h76:begin
                o_Cnd = (~(SF^OF))&(~ZF);
            end
            8'h70:begin
                o_Cnd = 1'b1;
            end
            default:begin
                o_Cnd = 1'b0;
            end
        endcase
    end
    
endmodule
