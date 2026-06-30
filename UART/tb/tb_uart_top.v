`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/30/2026 11:04:51 AM
// Design Name: 
// Module Name: tb_uart_top
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


module tb_uart_top;

    parameter CLKS_PER_BIT = 4;
    reg clk;
    reg rst;

    reg tx_start;
    reg [7:0] tx_data;
    reg [7:0] expected_data;

    wire tx;
    wire tx_busy;
    wire tx_done;

    wire [7:0] rx_data;
    wire rx_busy;
    wire rx_done;
    wire framing_error;

    wire serial_line;

    assign serial_line = tx;

    uart_top #(
        .CLKS_PER_BIT(CLKS_PER_BIT)
    ) dut (

        .clk(clk),
        .rst(rst),

        .tx_start(tx_start),
        .tx_data(tx_data),

        .tx(tx),
        .tx_busy(tx_busy),
        .tx_done(tx_done),

        .rx(serial_line),

        .rx_data(rx_data),
        .rx_busy(rx_busy),
        .rx_done(rx_done),
        .framing_error(framing_error)
    );

    initial
        clk = 0;

    always #10 clk = ~clk;

    initial begin

        $display("\n========== UART LOOPBACK TEST ==========\n");

        rst = 1;
        tx_start = 0;
        tx_data = 8'h00;
        expected_data = 8'h00;

        repeat(2)
            @(posedge clk);

        rst = 0;

        @(posedge clk);
        expected_data = 8'h53;
        tx_data = expected_data;
        tx_start = 1;

        @(posedge clk);
        tx_start = 0;

        wait(rx_done);
        repeat(5) @(posedge clk);

        expected_data = 8'hA5;
        tx_data = expected_data;
        tx_start = 1;

        @(posedge clk);
        tx_start = 0;

        wait(rx_done);
        repeat(5) @(posedge clk);

        expected_data = 8'h55;
        tx_data = expected_data;
        tx_start = 1;

        @(posedge clk);
        tx_start = 0;

        wait(rx_done);
        repeat(5) @(posedge clk);

        expected_data = 8'hAA;
        tx_data = expected_data;
        tx_start = 1;

        @(posedge clk);
        tx_start = 0;

        wait(rx_done);
        repeat(5) @(posedge clk);

        expected_data = 8'h00;
        tx_data = expected_data;
        tx_start = 1;

        @(posedge clk);
        tx_start = 0;

        wait(rx_done);
        repeat(5) @(posedge clk);

        expected_data = 8'hFF;
        tx_data = expected_data;
        tx_start = 1;

        @(posedge clk);
        tx_start = 0;

        wait(rx_done);
        repeat(10) @(posedge clk);

        $display("\n========== TEST COMPLETE ==========\n");

        $finish;

    end

    always @(posedge rx_done)
    begin

        $display("--------------------------------------------");
        $display("Time          : %0t", $time);
        $display("Expected Data : %h", expected_data);
        $display("Received Data : %h", rx_data);
        $display("Frame Error   : %b", framing_error);

        if(rx_data == expected_data && !framing_error)
            $display("RESULT        : PASS");
        else
            $display("RESULT        : FAIL");

        $display("--------------------------------------------\n");

    end

endmodule
