`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/25/2026 05:49:15 PM
// Design Name: 
// Module Name: tb_minutes_counter
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


module tb_minutes_counter;
    reg clk;
    reg rst;
    reg carry;

    wire minute_carry;
    wire [5:0] minutes;

    integer i;

    minutes_counter min_count_dut (
        .clk(clk),
        .rst(rst),
        .carry(carry),
        .minute_carry(minute_carry),
        .minutes(minutes)
    );

    
    always #5 clk = ~clk;

    always @(posedge clk) begin
            $display("t=%0t carry=%b minutes=%0d minute_carry=%b",
             $time, carry, minutes, minute_carry);
        end

    initial begin

        clk  = 0;
        rst  = 1;
        carry = 0;

        #20;
        rst = 0;
        
        for (i = 0; i < 65; i = i + 1) begin
            #10 carry = 1;   
            #10 carry = 0;   
        end

        #20;
        $finish;
    end
endmodule
