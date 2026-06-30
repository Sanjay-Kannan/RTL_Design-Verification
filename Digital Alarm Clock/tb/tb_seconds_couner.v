`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/25/2026 05:20:14 PM
// Design Name: 
// Module Name: tb_seconds_couner
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


module tb_seconds_counter;

    reg clk;
    reg rst;
    reg tick;

    wire carry;
    wire [5:0] seconds;

    integer i;

    seconds_counter sec_count_dut (
        .clk(clk),
        .rst(rst),
        .tick(tick),
        .carry(carry),
        .seconds(seconds)
    );

    
    always #5 clk = ~clk;

    always @(posedge clk) begin
            $display("t=%0t tick=%b seconds=%0d carry=%b",
             $time, tick, seconds, carry);
        end

    initial begin

        clk  = 0;
        rst  = 1;
        tick = 0;

        #20;
        rst = 0;

        for (i = 0; i < 65; i = i + 1) begin
            #10 tick = 1;   
            #10 tick = 0;   
        end

        #20;
        $finish;
    end

endmodule
