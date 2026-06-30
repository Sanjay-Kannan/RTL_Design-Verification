`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/29/2026 05:51:54 PM
// Design Name: 
// Module Name: tb_uart_rx
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


module tb_uart_rx;

    parameter CLKS_PER_BIT = 4;

    reg clk;
    reg rst;
    reg rx;
    wire [7:0] data_out;
    wire rx_done;
    wire busy;
    wire framing_error;

    uart_rx #(.CLKS_PER_BIT(CLKS_PER_BIT)) rx_dut (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .data_out(data_out),
        .rx_done(rx_done),
        .busy(busy),
        .framing_error(framing_error)
    );

    initial begin
        clk = 0;
    end

    always #10 clk = ~clk;

    task uart_send;
        input [7:0] data;
        integer i;
        begin
            $display("Sending %h at time %0t", data, $time);
            rx = 1'b1;
            repeat(CLKS_PER_BIT)
            @(posedge clk);

            rx = 1'b0;
            repeat(CLKS_PER_BIT)
                @(posedge clk);

            for(i = 0;i<8;i=i+1) begin
                rx = data[i];
                repeat(CLKS_PER_BIT)
                @(posedge clk);
            end

            rx = 1'b1;
            repeat(CLKS_PER_BIT)
                @(posedge clk);
            $display("Finished sending %h at time %0t", data, $time);
        end
    endtask

    initial begin
        $display("START OF TEST");
    
        rst = 1;
        rx  = 1;
    
        repeat(2) @(posedge clk);
    
        rst = 0;
    
        $display("About to send 53");
        uart_send(8'h53);
        $display("Finished sending 53");
    
        wait(rx_done);
    
        repeat(5) @(posedge clk);
    
        $display("About to send A5");
        uart_send(8'hA5);
        $display("Finished sending A5");
    
        wait(rx_done);
    
        $display("END OF TEST");
    
        #100;
        $finish;
    end

    always @(posedge clk)
    begin

        if(rx_done)
        begin

            $display("-------------------------------------");
            $display("Time           = %0t",$time);
            $display("Received Data  = %h",data_out);
            $display("Busy           = %b",busy);
            $display("Frame Error    = %b",framing_error);

        end

    end

    always @(posedge clk)
        begin
        $display("State=%0d RX=%b BaudCnt=%0d BitCnt=%0d",
        rx_dut.state,
        rx,
        rx_dut.baud_counter,
        rx_dut.bit_counter
        );
    end
endmodule
