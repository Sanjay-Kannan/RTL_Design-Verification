`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/25/2026 04:33:21 PM
// Design Name: 
// Module Name: tb_clock_divider
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


module tb_clock_divider;
    reg clk;
    reg rst;
    wire tick;

    clock_divider clk_div_dut(.clk(clk), .rst(rst), .tick(tick));

    always #5 clk = ~clk;
    initial begin
        $monitor("%0t count=%d tick=%b", $time,clk_div_dut.count, tick);
        clk = 0;
        rst = 1;
        #30 rst = 0;
        #550 $finish;
    end
endmodule
