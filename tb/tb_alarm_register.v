`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/26/2026 12:11:33 PM
// Design Name: 
// Module Name: tb_alarm_register
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


module tb_alarm_register;

    reg clk;
    reg rst;
    reg alarm_toggle;
    reg inc_hour;
    reg inc_min;

    wire [4:0] alarm_hour;
    wire [5:0] alarm_min;
    wire alarm_en;

    alarm_register dut (
        .clk(clk),
        .rst(rst),
        .alarm_toggle(alarm_toggle),
        .alarm_hour(alarm_hour),
        .alarm_min(alarm_min),
        .inc_hour(inc_hour),
        .inc_min(inc_min),
        .alarm_en(alarm_en)
    );

    always #5 clk = ~clk;

    always @(posedge clk) begin
        $display("Time=%0t | En=%b | Alarm=%02d:%02d | inc_hour=%b | inc_min=%b",
                 $time, alarm_en, alarm_hour, alarm_min,
                 inc_hour, inc_min);
    end

    initial begin
        clk          = 0;
        rst          = 1;
        alarm_toggle = 0;
        inc_hour     = 0;
        inc_min      = 0;
        #20;
        rst = 0;

        @(posedge clk);
        alarm_toggle = 1;

        @(posedge clk);
        alarm_toggle = 0;

        // repeat (3) begin
        //     @(posedge clk);
        //     inc_hour = 1;

        //     @(posedge clk);
        //     inc_hour = 0;
        // end

        // repeat (5) begin
        //     @(posedge clk);
        //     inc_min = 1;

        //     @(posedge clk);
        //     inc_min = 0;
        // end

        repeat (59) begin
            @(posedge clk);
            inc_min = 1;

            @(posedge clk);
            inc_min = 0;
        end

        repeat (23) begin
            @(posedge clk);
            inc_hour = 1;

            @(posedge clk);
            inc_hour = 0;
        end

        @(posedge clk);
        inc_min = 1;
        @(posedge clk);
        inc_min = 0;

        

        @(posedge clk);
        $finish;

    end

endmodule
