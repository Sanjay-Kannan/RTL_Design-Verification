`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/25/2026 04:15:23 PM
// Design Name: 
// Module Name: clock_divider
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


module clock_divider #(parameter integer DIVISOR = 10)(
    input clk,
    input rst,
    output tick
);

reg [$clog2(DIVISOR)-1:0] count;

always @(posedge clk) begin
    if (rst)
        count <= 0;
    else if (count == DIVISOR-1)
        count <= 0;
    else
        count <= count + 1;
end

assign tick = (count == DIVISOR-1);

endmodule
