`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/21 11:29:50
// Design Name: 
// Module Name: sim_seq_top
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


module sim_seq_top( );
    reg         i_clk;
    reg         i_rst_n;
    wire [15:0]  i_pc;
    reg  [15:0]  start;
    initial begin
        i_clk <= 1'b0;
        i_rst_n <= 1'b0;
        start <= 16'h0000;
        #300
        i_rst_n <= 1'b1;
        #50
        start <= 16'hffff;
    end
    always #10 i_clk <= ~i_clk;
    
    seq_top udeq_top(
        .i_clk          (i_clk          ),
        .i_rst_n        (i_rst_n        ),
        .src_pc         (16'h0000       ),
        .start          (start           )
    );
endmodule
