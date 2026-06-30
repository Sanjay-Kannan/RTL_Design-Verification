`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/26/2026 11:43:08 AM
// Design Name: 
// Module Name: set_alarm
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


module alarm_register #(parameter integer HOUR_LIMIT = 24, MINUTE_LIMIT = 60)(
    input clk,
    input rst,
    input alarm_toggle,
    input set_alarm_enable,
    output reg [4:0] alarm_hour,
    output  reg [5:0] alarm_min,
    input inc_hour,
    input inc_min,
    output reg alarm_en
    );
    

    always @(posedge clk) begin
        if(rst) begin
           alarm_en <= 0;
           alarm_hour <= 0;
           alarm_min <= 0;
        end
        else begin
                if(alarm_toggle)
                    alarm_en <= ~ alarm_en;
                if (set_alarm_enable && inc_hour && !inc_min) begin //simultaneous button press will ignore both buttons
                    if(alarm_hour < HOUR_LIMIT -1)
                        alarm_hour <= alarm_hour + 1;
                    else
                        alarm_hour <= 0;
                end
                else if (set_alarm_enable && inc_min && !inc_hour) begin
                    if(alarm_min < MINUTE_LIMIT -1)
                        alarm_min <= alarm_min + 1;
                    else begin
                        alarm_min <= 0;
                        if(alarm_hour < HOUR_LIMIT -1)
                            alarm_hour <= alarm_hour + 1;
                        else
                            alarm_hour <= 0;
                    end
            end
        end
    end
endmodule
