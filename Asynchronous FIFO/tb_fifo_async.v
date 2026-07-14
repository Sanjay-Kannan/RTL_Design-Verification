`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2026 05:08:11 PM
// Design Name: 
// Module Name: tb_fifo_async
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


module tb_fifo_async;

parameter DATA_WIDTH = 8;
parameter DEPTH      = 16;

reg wr_clk;
reg rd_clk;
reg rst;

reg wr_en;
reg rd_en;
reg [DATA_WIDTH-1:0] data_in;

wire [DATA_WIDTH-1:0] data_out;
wire full;
wire empty;

fifo_async #(
    .DATA_WIDTH(DATA_WIDTH),
    .DEPTH(DEPTH)
) fifo_dut (
    .wr_clk(wr_clk),
    .rd_clk(rd_clk),
    .rst(rst),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .data_in(data_in),
    .data_out(data_out),
    .full(full),
    .empty(empty)
);

//-----------------------------------------------------
// Clock Generation
//-----------------------------------------------------

initial
    wr_clk = 0;

always #5 wr_clk = ~wr_clk;      //100 MHz

initial
    rd_clk = 0;

always #8 rd_clk = ~rd_clk;      //62.5 MHz

//-----------------------------------------------------
// Write Task
//-----------------------------------------------------

task fifo_write;
    input [7:0] data;
    reg was_full;
begin

    was_full = full;

    @(posedge wr_clk);
    data_in <= data;
    wr_en   <= 1'b1;

    @(posedge wr_clk);
    wr_en <= 1'b0;

    #1;

    if(was_full)
        $display("[%0t] WRITE BLOCKED (FIFO FULL)", $time);
    else
        $display("[%0t] WRITE : %h   Count=%0d",
                  $time,
                  data,
                  fifo_dut.wr_ptr_bin);

end
endtask

//-----------------------------------------------------
// Read Task
//-----------------------------------------------------

task fifo_read;
    reg was_empty;
begin

    was_empty = empty;

    @(posedge rd_clk);
    rd_en <= 1'b1;

    @(posedge rd_clk);
    rd_en <= 1'b0;

    #1;

    if(was_empty)
        $display("[%0t] READ BLOCKED (FIFO EMPTY)",$time);
    else
        $display("[%0t] READ  : %h   Count=%0d",
                  $time,
                  data_out,
                  fifo_dut.rd_ptr_bin);

end
endtask

//-----------------------------------------------------
// Test Sequence
//-----------------------------------------------------

initial
begin

    rst = 1;
    wr_en = 0;
    rd_en = 0;
    data_in = 0;

    repeat(4)
        @(posedge wr_clk);

    rst = 0;

    $display("");
    $display("========== ASYNCHRONOUS FIFO TEST ==========");
    $display("");

    //------------------------------------------
    // Single Write / Read
    //------------------------------------------

    fifo_write(8'h53);
    fifo_read();

    //------------------------------------------
    // Multiple Writes
    //------------------------------------------

    fifo_write(8'h11);
    fifo_write(8'h22);
    fifo_write(8'h33);
    fifo_write(8'h44);

    //------------------------------------------
    // Multiple Reads
    //------------------------------------------

    fifo_read();
    fifo_read();

    //------------------------------------------
    // More Writes
    //------------------------------------------

    fifo_write(8'h55);
    fifo_write(8'h66);

    //------------------------------------------
    // Read Everything
    //------------------------------------------

    fifo_read();
    fifo_read();
    fifo_read();
    fifo_read();

    //------------------------------------------
    // Empty Read
    //------------------------------------------

    fifo_read();

    //------------------------------------------
    // Fill FIFO
    //------------------------------------------

    repeat(DEPTH)
        fifo_write($random);

    //------------------------------------------
    // Write when Full
    //------------------------------------------

    fifo_write(8'hAA);

    //------------------------------------------
    // Empty FIFO
    //------------------------------------------

    repeat(DEPTH)
        fifo_read();

    $display("");
    $display("========== TEST COMPLETE ==========");
    $display("");

    #100;
    $finish;

end

//-----------------------------------------------------
// Monitor
//-----------------------------------------------------

always @(posedge wr_clk)
begin
    $display("WR_CLK | wr_bin=%0d wr_gray=%b full=%b",
             fifo_dut.wr_ptr_bin,
             fifo_dut.wr_ptr_gray,
             full);
end

always @(posedge rd_clk)
begin
    $display("RD_CLK | rd_bin=%0d rd_gray=%b empty=%b",
             fifo_dut.rd_ptr_bin,
             fifo_dut.rd_ptr_gray,
             empty);
end

endmodule
