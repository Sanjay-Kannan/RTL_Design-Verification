`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/26/2026 08:36:21 PM
// Design Name: 
// Module Name: button_edge_detector
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


module button_edge_detector(
    input clk,
    input rst,
    input button,
    output pulse
);

    reg button_d;

    always @(posedge clk or posedge rst) begin
        if (rst)
            button_d <= 1'b0;
        else
            button_d <= button;
    end

    assign pulse = button & ~button_d;

endmodule
