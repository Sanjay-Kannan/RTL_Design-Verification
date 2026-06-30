`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/30/2026 10:40:40 AM
// Design Name: 
// Module Name: uart_top
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


module uart_top #(
    parameter integer CLKS_PER_BIT = 434
)(
    input clk,
    input rst,

    input tx_start,
    input [7:0] tx_data,
    output tx,
    output tx_busy,
    output tx_done,

    input rx,
    output [7:0] rx_data,
    output rx_busy,
    output rx_done,
    output framing_error
);

    wire baud_tick;

    baud_rate_generator #(
        .CLKS_PER_BIT(CLKS_PER_BIT)
    ) baud_gen (
        .clk(clk),
        .rst(rst),
        .enable(tx_busy),
        .baud_tick(baud_tick)
    );

    uart_tx #(
        .CLKS_PER_BIT(CLKS_PER_BIT)
    ) tx_inst (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick),
        .start(tx_start),
        .txin(tx_data),
        .tx(tx),
        .txdone(tx_done),
        .busy(tx_busy)
    );

    uart_rx #(
        .CLKS_PER_BIT(CLKS_PER_BIT)
    ) rx_inst (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .data_out(rx_data),
        .rx_done(rx_done),
        .busy(rx_busy),
        .framing_error(framing_error)
    );

endmodule
