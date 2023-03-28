`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/20 22:44:15
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
    input       [63:0]      i_valE          ,
    input       [63:0]      i_valA          ,
    input       [15:0]      i_valP          ,
    input       [3:0]       i_icode         ,
    input       [3:0]       i_ifun          ,
    
    input                   i_instr_valid   ,
    
    output      [63:0]      o_valM          ,
    output  reg [2:0]       o_stat      
    );
    
    localparam  SADR = 2'b00;
    localparam  SINS = 2'b01;
    localparam  SHLT = 2'b10;
    localparam  SAOK = 2'b11;
    
    reg         [15:0]          mem_addr    ;
    reg         [63:0]          mem_data    ;
    
    reg                         mem_en      ;//enable memory
    reg                         mem_wr      ;//1:write 0:read
    
    always @(*) begin
        case({i_icode,i_ifun}) 
            8'h40,
            8'h50,
            8'h80,
            8'ha0,
            8'h90,
            8'hb0:begin
                mem_en = 1'b1;
            end
            default:begin
                mem_en = 1'b0;
            end
        endcase
    end
    
   always @(*) begin
        case({i_icode,i_ifun}) 
            8'h40,
            8'h80,
            8'ha0:begin
                mem_wr = 1'b1;
            end
            8'h50,
            8'h90,
            8'hb0:begin
                mem_wr = 1'b0;
            end
            default:begin
                mem_wr = 1'b0;
            end
        endcase
    end 
    
    always @(*) begin
        case({i_icode,i_ifun}) 
            8'h40,
            8'h50,
            8'h80,
            8'ha0:begin
                mem_addr = i_valE;
            end
            8'h90,
            8'hb0:begin
                mem_addr = i_valA;
            end
        endcase
    end   
    
    always @(*) begin
        case({i_icode,i_ifun}) 
            8'h40,
            8'ha0:begin
                mem_data = i_valA;
            end
            8'h80:begin
                mem_data = i_valP;
            end
        endcase
    end 
    
    dmem u_dmem(
        .i_mem_addr     (mem_addr[15:0] ),
        .i_mem_wr_data  (mem_data       ),
        .i_mem_en       (mem_en         ),
        .i_mem_wr       (mem_wr         ),
        .o_mem_rd_data  (o_valM         )
    );
    
    always @(*) begin
        if((mem_addr[63]==1'b1)||(mem_addr > 64'd65536)) begin
            o_stat = SADR;
        end
        else if(!i_instr_valid) begin
            o_stat = SINS;
        end
        else if(i_icode == 4'h0) begin
            o_stat = SHLT;
        end
        else begin
            o_stat = SAOK;
        end
    end
    
endmodule
