`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/19 18:38:12
// Design Name: 
// Module Name: sim_fetch
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


module sim_fetch();
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
    
    fetch ufetch(
        .i_clk          (i_clk          ),
        .i_rst_n        (i_rst_n        ),
        .i_pc           (((i_pc&(start))|(16'h0000&(~start))) ),
        .o_valP         (i_pc           )
    );
    
//    always @(posedge i_clk or negedge i_rst_n) begin
//        if(!i_rst_n) begin
//            i_pc <= 16'h0020;
//        end
//        else begin
//            case(i_pc) 
//                16'h0020:begin
//                    i_pc <= 16'h0000;
//                end
//                16'h0000:begin
//                    i_pc <= i_pc + 16'd10;
//                end
//                16'd10:begin
//                    i_pc <= i_pc + 16'd2;
//                end
//                16'd12:begin
//                    i_pc <= i_pc + 16'd2;
//                end
//                default:begin
//                    i_pc <= i_pc;
//                end
//            endcase
//        end
//    end
endmodule
