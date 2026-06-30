`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/25/2026 05:43:55 PM
// Design Name: 
// Module Name: minutes_counter
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


module minutes_counter #(parameter integer MINUTE_LIMIT = 60)(
    input clk,
    input rst,
    input carry,
    input clock_enable,
    input set_time_enable,
    input inc_min,
    output  reg [5:0] minutes,
    output reg minute_carry
    );

    always @(posedge clk) begin
        if (rst) begin 
            minutes <= 0;
            minute_carry <= 0;
        end
        else begin
            minute_carry <= 0;

            if(clock_enable && carry) begin
                if(minutes < MINUTE_LIMIT - 1)
                    minutes <= minutes + 1;
                else begin
                    minutes <= 0;
                    minute_carry <= 1;
                end
            end
        
            else if(set_time_enable && inc_min) begin
                if(minutes < MINUTE_LIMIT - 1)
                    minutes <= minutes + 1;
                else begin
                    minutes <= 0;
                    minute_carry <= 1;
                end
            end
        end
    end
endmodule
