`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/26/2026 11:23:03 AM
// Design Name: 
// Module Name: tb_hour_counter
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


module tb_hour_counter;

        reg clk;
    reg rst;
    reg minute_carry;

    wire day_carry;
    wire [4:0] hours;

    integer i;

    hour_counter hour_count_dut (
        .clk(clk),
        .rst(rst),
        .minute_carry(minute_carry),
        .day_carry(day_carry),
        .hours(hours)
    );

    
    always #5 clk = ~clk;

    always @(posedge clk) begin
            $display("t=%0t minute_carry=%b hours=%0d day_carry=%b",
             $time, minute_carry, hours, day_carry);
        end

    initial begin

        clk  = 0;
        rst  = 1;
        minute_carry = 0;

        #20;
        rst = 0;
        
        for (i = 0; i < 26; i = i + 1) begin
            #10 minute_carry = 1;   
            #10 minute_carry = 0;   
        end

        #20;
        $finish;
    end
endmodule
