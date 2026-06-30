`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/25/2026 05:04:38 PM
// Design Name: 
// Module Name: seconds_counter
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


module seconds_counter #(parameter integer SECOND_LIMIT = 60)(
    input clk,
    input rst,
    input tick,
    input clock_enable,
    output carry,
    output reg [5:0] seconds
    );

    always @(posedge clk) begin
        if (rst) begin
            seconds <= 0;
        end
        else if(clock_enable && (tick == 1) && (seconds < SECOND_LIMIT - 1))
            seconds <= seconds + 1;
        else if(clock_enable && (tick ==1) && (seconds == SECOND_LIMIT - 1)) begin
            seconds <= 0;
        end
    end

    assign carry = ((tick) && (seconds == SECOND_LIMIT -1) );
endmodule
