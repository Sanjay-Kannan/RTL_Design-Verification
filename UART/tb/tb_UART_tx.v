`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/29/2026 11:35:43 AM
// Design Name: 
// Module Name: tb_UART_tx
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


module tb_uart_tx;
    reg clk;
    reg rst;
    reg start;
    reg [7:0] txin;

    wire baud_tick;
    wire tx;
    wire txdone;
    wire busy;

    uart_tx dut(
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick),
        .start(start),
        .txin(txin),
        .tx(tx),
        .txdone(txdone),
        .busy(busy)
    );

    baud_rate_generator #(
        .CLKS_PER_BIT(4)
    ) baud_gen (
        .clk(clk),
        .rst(rst),
        .enable(busy),
        .baud_tick(baud_tick)
    );

    initial
        clk = 0;

    always #10 clk = ~clk;

    initial
    begin
        rst   = 1;
        start = 0;
        txin  = 8'h00;

        repeat(2) @(posedge clk);

        rst = 0;

        @(posedge clk);

        txin  = 8'h53;
        start = 1;

        @(posedge clk);
        start = 0;

        wait(txdone);

        repeat(5) @(posedge clk);

        txin  = 8'hA5;
        start = 1;

        @(posedge clk);
        start = 0;

        wait(txdone);

        repeat(10) @(posedge clk);

        $finish;

    end

    initial
    begin
        $display("---------------------------------------------------------------");
        $display(" Time\tState\tTX\tBusy\tBit\tShift Register");
        $display("---------------------------------------------------------------");
    end

    always @(posedge baud_tick)
    begin
        if(busy)
        begin
            $display("%0t\t%0d\t%b\t%b\t%0d\t%b",
                $time,
                dut.state,
                tx,
                busy,
                dut.bit_counter,
                dut.shift_reg
            );
        end
    end
    initial
    begin
        $dumpfile("uart_tx.vcd");
        $dumpvars(0, tb_uart_tx);
    end

endmodule