`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/29/2026 10:23:05 AM
// Design Name: 
// Module Name: baud_rate_generator
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

module baud_rate_generator #(
    parameter integer CLK_FREQ  = 100_000,
    parameter integer BAUD_RATE = 9600
)(
    input  wire clk,
    input  wire rst,
    input  wire enable,

    output reg  baud_tick
);

    localparam integer WAIT_COUNT = CLK_FREQ / BAUD_RATE;

    reg [$clog2(WAIT_COUNT)-1:0] count;

    always @(posedge clk or posedge rst)
    begin
        if (rst || !enable)
        begin
            count     <= 0;
            baud_tick <= 1'b0;
        end

        else
        begin
            if (count == WAIT_COUNT-1)
            begin
                count     <= 0;
                baud_tick <= 1'b1;
            end
            else
            begin
                count     <= count + 1'b1;
                baud_tick <= 1'b0;
            end
        end
    end

endmodule
