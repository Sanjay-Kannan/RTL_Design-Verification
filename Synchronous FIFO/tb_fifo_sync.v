`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/30/2026 01:47:57 PM
// Design Name: 
// Module Name: tb_fifo_sync
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


module tb_fifo_sync;
    parameter DATA_WIDTH = 8;
    parameter DEPTH = 4;

    reg clk;
    reg rst;
    reg wr_en;
    reg rd_en;
    reg [DATA_WIDTH -1:0]data_in;
    wire [DATA_WIDTH -1:0]data_out;
    wire full;
    wire empty;

    fifo_sync #(.DATA_WIDTH(DATA_WIDTH), .DEPTH(DEPTH)) fifo_dut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    initial 
        clk = 0;
    
    always #10 clk = ~clk;

    task fifo_write;
        reg was_full;
        input [DATA_WIDTH-1:0] data;
        begin
            was_full = full;
            @(posedge clk);
            data_in <= data;
            wr_en <= 1'b1;
            rd_en <= 1'b0;

            @(posedge clk);
            wr_en <= 1'b0;
            #1;
            if(was_full)
                $display("[%0t] WRITE BLOCKED (FIFO FULL)", $time);
            else
                $display("WRITE : Time = %0t Data = %h Full = %b Empty = %b Count = %0d",$time, data, full, empty, fifo_dut.count);
        end
    endtask

    task fifo_read;
    reg was_empty;
        begin
            was_empty = empty;

            @(posedge clk);
            wr_en <= 1'b0;
            rd_en <= 1'b1;

            @(posedge clk);
            rd_en <= 1'b0;
            #1;
            if(was_empty)
                $display("[%0t] READ BLOCKED (FIFO EMPTY)", $time);
            else
                $display("READ  : Time = %0t Data_Out = %h Full = %b Empty = %b Count = %0d",
                        $time, data_out, full, empty, fifo_dut.count);
        end
    endtask

    initial begin

    rst = 1;
    wr_en = 0;
    rd_en = 0;
    data_in = 0;

    repeat(2)
        @(posedge clk);

    rst = 0;

    //----------------------------------
    // Single Write / Read
    //----------------------------------

    fifo_write(8'h53);
    fifo_read();

    //----------------------------------
    // Fill FIFO
    //----------------------------------

    fifo_write(8'h11);
    fifo_write(8'h22);
    fifo_write(8'h33);
    fifo_write(8'h44);

    //----------------------------------
    // Write when Full
    //----------------------------------

    fifo_write(8'h55);

    //----------------------------------
    // Empty FIFO
    //----------------------------------

    fifo_read();
    fifo_read();
    fifo_read();
    fifo_read();

    //----------------------------------
    // Read when Empty
    //----------------------------------

    fifo_read();

    #50;
    $finish;

end
endmodule
