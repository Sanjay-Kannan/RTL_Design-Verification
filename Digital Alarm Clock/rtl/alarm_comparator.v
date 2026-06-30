`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/26/2026 12:33:59 PM
// Design Name: 
// Module Name: alarm_comparator
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


module alarm_comparator(
    input [4:0] current_hour,
    input [5:0] current_min,
    input [4:0] alarm_hour,
    input [5:0] alarm_min,
    input [5:0] current_sec,
    input alarm_en,
    output alarm_match
    );

    assign alarm_match = (alarm_en && (current_hour == alarm_hour) && (current_min == alarm_min) && (current_sec == 0));
endmodule
