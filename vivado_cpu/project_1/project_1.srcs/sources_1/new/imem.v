`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/19 11:51:40
// Design Name: 
// Module Name: imem
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


module imem(
    input       [15:0]              i_pc            ,
    output      [79:0]              o_instr   
    );
    
    wire        [7:0]               ROM[99:0]       ;
    assign      ROM[0] = 8'h30;
    assign      ROM[1] = 8'hf4;
    assign      ROM[2] = 8'h00;
    assign      ROM[3] = 8'h00;
    assign      ROM[4] = 8'h00;
    assign      ROM[5] = 8'h00;
    assign      ROM[6] = 8'h00;
    assign      ROM[7] = 8'h00;
    assign      ROM[8] = 8'h00;
    assign      ROM[9] = 8'h28;//40
    assign      ROM[10] = 8'h30;
    assign      ROM[11] = 8'hf8;
    assign      ROM[12] = 8'h00;
    assign      ROM[13] = 8'h00;
    assign      ROM[14] = 8'h00;
    assign      ROM[15] = 8'h00;
    assign      ROM[16] = 8'h00;
    assign      ROM[17] = 8'h00;
    assign      ROM[18] = 8'h00;
    assign      ROM[19] = 8'h08;
    assign      ROM[20] = 8'h30;
    assign      ROM[21] = 8'hf9;
    assign      ROM[22] = 8'h00;
    assign      ROM[23] = 8'h00;
    assign      ROM[24] = 8'h00;
    assign      ROM[25] = 8'h00;
    assign      ROM[26] = 8'h00;
    assign      ROM[27] = 8'h00;
    assign      ROM[28] = 8'h00;
    assign      ROM[29] = 8'h01;
    assign      ROM[30] = 8'h60;
    assign      ROM[31] = 8'h89;
    assign      ROM[32] = 8'h61;
    assign      ROM[33] = 8'h89;
    assign      ROM[34] = 8'h75;
    assign      ROM[35] = 8'h00;
    assign      ROM[36] = 8'h00;
    assign      ROM[37] = 8'h00;
    assign      ROM[38] = 8'h00;
    assign      ROM[39] = 8'h00;
    assign      ROM[40] = 8'h00;
    assign      ROM[41] = 8'h00;
    assign      ROM[42] = 8'h2d;
    assign      ROM[43] = 8'h00;
    assign      ROM[44] = 8'h00;
    assign      ROM[45] = 8'ha0;
    assign      ROM[46] = 8'h9f;
    assign      ROM[47] = 8'hb0;
    assign      ROM[48] = 8'h8f;
    assign      ROM[49] = 8'h80;
    assign      ROM[50] = 8'h00;
    assign      ROM[51] = 8'h00;
    assign      ROM[52] = 8'h00;
    assign      ROM[53] = 8'h00;
    assign      ROM[54] = 8'h00;
    assign      ROM[55] = 8'h00;
    assign      ROM[56] = 8'h00;
    assign      ROM[57] = 8'h4e;
    assign      ROM[58] = 8'h50;
    assign      ROM[59] = 8'h98;
    assign      ROM[60] = 8'h00;
    assign      ROM[61] = 8'h00;
    assign      ROM[62] = 8'h00;
    assign      ROM[63] = 8'h00;
    assign      ROM[64] = 8'h00;
    assign      ROM[65] = 8'h00;
    assign      ROM[66] = 8'h00;
    assign      ROM[67] = 8'h1f;
    assign      ROM[68] = 8'h40;
    assign      ROM[69] = 8'h98;
    assign      ROM[70] = 8'h00;
    assign      ROM[71] = 8'h00;
    assign      ROM[72] = 8'h00;
    assign      ROM[73] = 8'h00;
    assign      ROM[74] = 8'h00;
    assign      ROM[75] = 8'h00;
    assign      ROM[76] = 8'h00;
    assign      ROM[77] = 8'h04;
    assign      ROM[78] = 8'h63;
    assign      ROM[79] = 8'h89;
    assign      ROM[80] = 8'h90;
    generate
    genvar i;
        for (i=0 ; i<10; i = i+1) begin
            assign o_instr[(i+1)*8-1:i*8] = ROM[i_pc + 9-i]; 
        end
    endgenerate
    
endmodule
