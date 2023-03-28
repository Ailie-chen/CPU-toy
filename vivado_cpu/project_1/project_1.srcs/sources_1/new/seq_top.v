`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/21 10:34:57
// Design Name: 
// Module Name: seq_top
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


module seq_top(
    input           i_clk           ,
    input           i_rst_n         ,
    input           src_pc          ,
    input           start
    
  );

    wire                [15:0]      next_pc     ;
    wire                [3:0]       icode       ;
    wire                [3:0]       ifun        ;
    
    wire                [3:0]       rA          ;
    wire                [3:0]       rB          ;
    wire                [63:0]      valC        ;
    wire                            instr_valid ;
    wire                [15:0]      valP       ;
    
    wire                [15:0]      pc          ;
    
    assign pc = &(start)? next_pc:16'h0000;
    fetch ufetch(
        .i_clk          (i_clk          ),
        .i_rst_n        (i_rst_n        ),
        .i_pc           (pc             ),
        .o_icode        (icode          ),
        .o_ifun         (ifun           ),
        .o_rA           (rA             ),
        .o_rB           (rB             ),
        .o_valC         (valC           ),
        .o_instr_valid  (instr_valid    ),
        .o_valP         (valP           )
    );
    
    wire        [63:0]      valA        ;
    wire        [63:0]      valB        ;
    
    wire        [63:0]      valE        ;
    wire        [63:0]      valM        ;
    decode_write u_decode_write
    (
        .i_clk          (i_clk          ),
        .i_icode        (icode          ),
        .i_ifun         (ifun           ),
        .i_rA           (rA             ),
        .i_rB           (rB             ),
        .o_valA         (valA           ),
        .o_valB         (valB           ),
        .i_valE         (valE           ),
        .i_valM         (valM           )
    );
    wire                        cnd     ;
    execute u_execute(
        .i_icode        (icode          ),
        .i_ifun         (ifun           ),
        .i_valA         (valA           ),
        .i_valB         (valB           ),
        .i_valC         (valC           ),
        
        .o_Cnd          (cnd            ),
        .o_valE         (valE           )
    );
    wire        [1:0]           stat    ;
    mem_access u_mem_access(
        .i_valE         (valE           ),
        .i_valA         (valA           ),
        .i_valP         (valP           ),
        .i_icode        (icode          ),
        .i_ifun         (ifun           ),
        .i_instr_valid  (instr_valid    ),
        
        .o_valM         (valM           ),
        .o_stat         (stat           )
    );
    
    pc_fresh u_pc_fresh(
        .i_icode        (icode          ),
        .i_ifun         (ifun           ),
        .i_valC         (valC           ),
        .i_valM         (valM           ),
        .i_cnd          (cnd            ),
        .i_valP         (valP           ),
        .o_next_pc      (next_pc        )
    );
endmodule
