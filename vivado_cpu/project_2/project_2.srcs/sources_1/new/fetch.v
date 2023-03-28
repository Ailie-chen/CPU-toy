`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/23 10:34:45
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
    input                           i_clk           ,
    input           [15:0]          i_pc            ,//current instr
    input           [3:0]           i_M_icode       ,
    input                           i_M_Cnd         ,
    input           [63:0]          i_M_valA        ,
    input           [3:0]           i_W_icode       ,
    input           [63:0]          i_W_valM        ,
    output  reg     [15:0]          o_F_predPC      ,
    output  reg     [1:0]           o_D_stat        ,
    output  reg     [3:0]           o_D_icode       ,
    output  reg     [3:0]           o_D_ifun        ,
    output  reg     [3:0]           o_D_rA          ,
    output  reg     [3:0]           o_D_rB          ,
    output  reg     [63:0]          o_D_valC        ,
    output  reg     [63:0]          o_D_valP        ,
    
    input                           i_F_stall       ,
    input                           i_D_stall       ,
    input                           i_D_bubble      
    );

    reg         [15:0]          current_pc          ;
    wire        [79:0]          instr               ;
    reg                         need_rigids         ;
    reg                         need_valC           ;
    wire        [3:0]           icode               ;
    wire        [3:0]           ifun                ;
    
    assign  icode = instr[79:76];
    assign  ifun  = instr[75:72];
  
    always @(*) begin
        if((i_M_icode == 4'h7) && (!i_M_Cnd)) begin
            current_pc = i_M_valA;
        end
        else if(i_W_icode == 4'h9) begin
            current_pc = i_W_valM;
        end
        else begin
            current_pc = i_pc;
        end
    end
    
    imem u_imem(
        .i_pc                           (current_pc     ),
        .o_instr                        (instr          )
    );
   
    
    always @(*) begin
        case(icode)
            4'h0,
            4'h1,
            4'h7,
            4'h8,
            4'h9:begin
                need_rigids = 1'b0;
            end
            default: begin
                need_rigids = 1'b1;
            end
        endcase
    end
    
    always @(*) begin
        case({icode,ifun}) 
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
                need_valC = 1'b1;
            end
            default:begin
                need_valC  = 1'b0;
            end
        endcase
    end
    
    always @(*) begin
        case({icode,ifun})
            8'h00:begin
                o_D_stat <= 2'b10;
            end
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
                o_D_stat <= 2'b11;
            end
            default:begin
                o_D_stat <= 2'b00;
            end
        endcase
    end
    
    always @(posedge i_clk) begin
        if(need_valC) begin
            if(icode == 4'h7 || icode == 4'h8) begin
                o_D_valC = instr[71:8];
            end
            else begin
                o_D_valC = instr[63:0];
            end
        end
        else begin
            o_D_valC = 64'd0;
        end
    end
    always @(posedge i_clk) begin
        if(i_F_stall == 1'b1) begin
            o_F_predPC <= o_F_predPC;
        end
        else if(icode == 4'h7 || icode == 4'h8) begin
            o_F_predPC <= instr[71:8];
        end
        else begin
            o_F_predPC <= current_pc + 16'h1 + need_valC*16'h8 + need_rigids;
        end
    end
    
    always @(posedge i_clk) begin
        if(i_D_stall) begin
            o_D_rA <= o_D_rA; 
        end    
        else if(need_rigids) begin
            o_D_rA <= instr[71:68];
        end
        else begin
            o_D_rA <= 4'hf;
        end
    end
    
    always @(posedge i_clk) begin
        if(i_D_stall) begin
            o_D_rB <= o_D_rB; 
        end    
        else if(need_rigids) begin      
            o_D_rB <= instr[67:64];
        end
        else begin
            o_D_rB <= 4'hf;
        end
    end
    
    always @(posedge i_clk ) begin
        if(i_D_stall) begin
            o_D_icode <= o_D_icode;
        end
        else if (i_D_bubble) begin
            o_D_icode <= 4'h0;
        end
        else begin
            o_D_icode <= icode;
        end
    end
    
    always @(posedge i_clk ) begin
        if(i_D_stall) begin
            o_D_ifun <= ifun;
        end
        else if (i_D_bubble) begin
            o_D_ifun <= 4'h0;
        end
        else begin
            o_D_ifun <= ifun;
        end
    end
    
    always @(posedge i_clk) begin
        o_D_valP = current_pc + 16'h1 + need_valC*16'h8 + need_rigids;
    end
endmodule
