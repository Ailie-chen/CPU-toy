`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/24 11:48:45
// Design Name: 
// Module Name: pipe_top
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


module pipe_top(
    input           i_clk           ,
    input           i_rst_n         ,
    input           src_pc          ,
    input           start
    );
    
    wire                [15:0]      pc          ;
    wire                [15:0]      next_pc     ;
    assign pc = &(start)? F_predPC:16'h0000;
    
    
    wire            [3:0]       M_icode     ;
    wire            [3:0]       M_Cnd       ;
    wire            [63:0]      M_valA      ;
    wire            [3:0]       W_icode     ;
    wire            [63:0]      W_valM      ;
    
    wire            [15:0]      F_predPC    ;
    wire            [1:0]       D_stat      ;
    wire            [3:0]       D_icode     ;
    wire            [3:0]       D_ifun      ;
    wire            [3:0]       D_rA        ;
    wire            [3:0]       D_rB        ;
    wire            [63:0]      D_valC      ;
    wire            [63:0]      D_valP      ;
    
    wire                        F_stall     ;
    wire                        D_stall     ;
    wire                        D_bubble    ;
    fetch ufetch
    (
        .i_clk          (i_clk          ),
        .i_pc           (pc             ),
        .i_M_icode      (M_icode        ),
        .i_M_Cnd        (M_Cnd          ),
        .i_M_valA       (M_valA         ),
        .i_W_icode      (W_icode        ),
        .i_W_valM       (W_valM         ),
        .o_F_predPC     (F_predPC       ),
        .o_D_stat       (D_stat         ),
        .o_D_icode      (D_icode        ),
        .o_D_ifun       (D_ifun         ),
        .o_D_rA         (D_rA           ),
        .o_D_rB         (D_rB           ),
        .o_D_valC       (D_valC         ),
        .o_D_valP       (D_valP         ),
        
        .i_F_stall      (F_stall        ),
        .i_D_stall      (D_stall        ),
        .i_D_bubble     (D_bubble       )
        
    );
    wire            [1:0]       E_stat      ;
    wire            [3:0]       E_icode     ;
    wire            [3:0]       E_ifun      ;
    wire            [63:0]      E_valC      ;
    wire            [63:0]      E_valA      ;
    wire            [63:0]      E_valB      ;
    wire            [3:0]       E_dstE      ;
    wire            [3:0]       E_dstM      ;
    wire            [3:0]       E_srcA      ;
    wire            [3:0]       E_srcB      ;
    
    wire            [3:0]       e_dstE      ;
    wire            [63:0]      e_valE      ;
    wire            [3:0]       M_dstE      ;
    wire            [63:0]      M_valE      ;
    wire            [3:0]       M_dstM      ;
    wire            [63:0]      m_valM      ;
    wire            [3:0]       W_dstM      ;
    wire            [3:0]       W_dstE      ;
    wire            [63:0]      W_valE      ;     
    
    wire                        E_bubble    ;
    
    wire            [3:0]       d_srcA      ;
    wire            [3:0]       d_srcB      ;
    decode_write udecode_write(
        .i_clk          (i_clk          ),
        .i_D_stat       (D_stat         ),
        .i_D_icode      (D_icode        ),
        .i_D_ifun       (D_ifun         ),
        .i_D_rA         (D_rA           ),
        .i_D_rB         (D_rB           ),
        .i_D_valC       (D_valC         ),
        .i_D_valP       (D_valP         ),
        
        .o_E_stat       (E_stat         ),
        .o_E_icode      (E_icode        ),
        .o_E_ifun       (E_ifun         ),
        .o_E_valC       (E_valC         ),
        .o_E_valA       (E_valA         ),
        .o_E_valB       (E_valB         ),
        .o_E_dstE       (E_dstE         ),
        .o_E_dstM       (E_dstM         ),
        .o_E_srcA       (E_srcA         ),
        .o_E_srcB       (E_srcB         ),
        
        .i_e_dstE       (e_dstE         ),
        .i_e_valE       (e_valE         ),
        .i_M_dstE       (M_dstE         ),
        .i_M_valE       (M_valE         ),
        .i_M_dstM       (M_dstM         ),
        .i_m_valM       (m_valM         ),
        .i_W_dstM       (W_dstM         ),
        .i_W_valM       (W_valM         ),
        .i_W_dstE       (W_dstE         ),
        .i_W_valE       (W_valE         ),
        
        .i_E_bubble     (E_bubble       ),
        
        .o_d_srcA       (d_srcA         ),
        .o_d_srcB       (d_srcB         )
    );
    
    wire            [1:0]           M_stat      ;
    wire            [1:0]           W_stat      ;
    wire            [1:0]           m_stat      ;
    
    wire                            M_bubble    ;
    wire                            e_Cnd       ;    
    
    execute uexecute(
        .i_clk          (i_clk          ),
        .i_E_stat       (E_stat         ),
        .i_E_icode      (E_icode        ),
        .i_E_ifun       (E_ifun         ),
        .i_E_valC       (E_valC         ),
        .i_E_valA       (E_valA         ),
        .i_E_valB       (E_valB         ),
        .i_E_dstE       (E_dstE         ),
        .i_E_dstM       (E_dstM         ),
        
        .o_M_stat       (M_stat         ),
        .o_M_icode      (M_icode        ),
        .o_M_Cnd        (M_Cnd          ),
        .o_M_valE       (M_valE         ),
        .o_M_valA       (M_valA         ),
        .o_M_dstE       (M_dstE         ),
        .o_M_dstM       (M_dstM         ),
        
        .i_W_stat       (W_stat         ),
        .i_m_stat       (m_stat         ),
        .o_e_dstE       (e_dstE         ),
        .o_e_valE       (e_valE         ),
        
        .i_M_bubble     (M_bubble       ),
        .o_e_Cnd        (e_Cnd          )
    );      
    
    
    wire                        W_stall     ;
    mem_access  umem_access(
        .i_clk          (i_clk          ),
        .i_M_stat       (M_stat         ),
        .i_M_icode      (M_icode        ),
        .i_M_valE       (M_valE         ),
        .i_M_valA       (M_valA         ),
        .i_M_dstE       (M_dstE         ),
        .i_M_dstM       (M_dstM         ),
        
        .o_W_valE       (W_valE         ),
        .o_W_valM       (W_valM         ),
        .o_W_dstE       (W_dstE         ),
        .o_W_dstM       (W_dstM         ),
        .o_W_stat       (W_stat         ),
        .o_W_icode      (W_icode        ),
        
        .o_m_valM       (m_valM         ),
        .i_W_stall      (W_stall        ),
        .o_m_stat       (m_stat         )
    );
    
    pipe_ctrl   upipe_ctrl(
        .i_E_icode      (E_icode        ),
        .i_E_dstM       (E_dstM         ),
        .i_D_icode      (D_icode        ),
        .i_M_icode      (M_icode        ),
        .i_e_Cnd        (e_Cnd          ),
        .i_d_srcA       (d_srcA         ),
        .i_d_srcB       (d_srcB         ),
        .i_m_stat       (m_stat         ),
        .i_W_stat       (W_stat         ),
        
        .o_F_stall      (F_stall        ),
        .o_D_stall      (D_stall        ),
        .o_D_bubble     (D_bubble       ),
        .o_E_bubble     (E_bubble       ),
        .o_M_bubble     (M_bubble       ),
        .o_W_stall      (W_stall        )
    );
endmodule
