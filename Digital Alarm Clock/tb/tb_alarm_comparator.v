`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/26/2026 12:37:45 PM
// Design Name: 
// Module Name: tb_alarm_comparator
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


module tb_alarm_comparator;

    reg [4:0] current_hour;
    reg [5:0] current_min;
    reg [4:0] alarm_hour;
    reg [5:0] alarm_min;
    reg alarm_en;
    wire alarm_match;

    alarm_comparator alarm_comparator_dut (
    .current_hour(current_hour),
    .current_min(current_min),
    .alarm_hour(alarm_hour),
    .alarm_min(alarm_min),
    .alarm_en(alarm_en),
    .alarm_match(alarm_match)
    );

    initial begin
    $monitor("Time=%0t | Current=%02d:%02d | Alarm=%02d:%02d | En=%b | Match=%b",
             $time,
             current_hour, current_min,
             alarm_hour, alarm_min,
             alarm_en,
             alarm_match);
    end
    

    initial begin
        current_hour = 0;
        current_min = 0;
        alarm_en = 0;
        alarm_hour = 0;
        alarm_min = 0;

        #20;
        current_hour = 6;
        current_min = 30;
        alarm_en = 1;
        alarm_hour = 6;
        alarm_min = 30;

        #20;
        current_hour = 9;
        current_min = 46;
        alarm_en = 0;
        alarm_hour = 9;
        alarm_min = 46;

        #20;
        current_hour = 23;
        current_min = 59;
        alarm_en = 1;
        alarm_hour = 23;
        alarm_min = 58;

        #20;
        $finish;

    end

endmodule
