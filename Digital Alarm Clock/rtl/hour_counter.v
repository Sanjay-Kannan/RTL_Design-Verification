`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/26/2026 11:07:58 AM
// Design Name: 
// Module Name: hour_counter
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


module hour_counter #(parameter integer HOUR_LIMIT = 24)(
        input clk, rst, minute_carry, clock_enable, inc_hour, set_time_enable,
        output reg [4:0] hours,
        output reg day_carry
    );

        always @(posedge clk) begin
        if (rst) begin
            hours <= 0;
            day_carry <= 0;
        end
        else begin
            day_carry <= 0;

            if(clock_enable && minute_carry) begin
                if(hours < HOUR_LIMIT - 1)
                    hours <= hours + 1;
                else begin
                    hours <= 0;
                    day_carry <= 1;
                end
            end

            else if(set_time_enable && inc_hour) begin
                if(hours < HOUR_LIMIT - 1)
                    hours <= hours + 1;
                else begin
                    hours <= 0;
                    day_carry <= 1;
                end
            end
        end
    end
endmodule
