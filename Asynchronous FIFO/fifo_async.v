`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/01/2026 10:09:22 AM
// Design Name: 
// Module Name: fifo_async
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


module fifo_async #(parameter DATA_WIDTH = 8, 
                    parameter DEPTH = 16)(
    input wr_clk,
    input rd_clk,
    input rst,
    input wr_en,
    input rd_en,
    input [DATA_WIDTH-1:0]data_in,
    output [DATA_WIDTH-1:0]data_out,
    output reg full,
    output reg empty
    );

    localparam ADDR_WIDTH = $clog2(DEPTH);

    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    reg [ADDR_WIDTH:0] wr_ptr_bin;
    reg [ADDR_WIDTH:0] rd_ptr_bin;

    reg [ADDR_WIDTH:0] wr_ptr_gray;
    reg [ADDR_WIDTH:0] rd_ptr_gray;

    reg [ADDR_WIDTH:0] rd_ptr_gray_sync1;
    reg [ADDR_WIDTH:0] rd_ptr_gray_sync2;

    reg [ADDR_WIDTH:0] wr_ptr_gray_sync1;
    reg [ADDR_WIDTH:0] wr_ptr_gray_sync2;

    wire [ADDR_WIDTH:0] wr_ptr_bin_next;
    wire [ADDR_WIDTH:0] wr_ptr_gray_next;

    wire [ADDR_WIDTH:0] rd_ptr_gray_next;
    wire [ADDR_WIDTH:0] rd_ptr_gray_next;

    assign wr_ptr_bin_next  = wr_ptr_bin + (wr_en && !full);
    assign wr_ptr_gray_next = wr_ptr_bin_next ^ (wr_ptr_bin_next >> 1);

    assign rd_ptr_bin_next  = rd_ptr_bin + (rd_en && !empty);
    assign rd_ptr_gray_next = rd_ptr_bin_next ^ (rd_ptr_bin_next >> 1);

    always @(posedge wr_clk or posedge rst) begin
        if(rst) begin
            wr_ptr_bin <= 0;
            wr_ptr_gray <= 0;
            full <= 1'b0;
        end
        else begin
        if(wr_en && !full) begin
            mem[wr_ptr_bin[ADDR_WIDTH-1:0]] <= data_in;
        end
        wr_ptr_bin  <= wr_ptr_bin_next;
        wr_ptr_gray <= wr_ptr_gray_next;

        full <=
        (
            wr_ptr_gray_next ==
            {
                ~rd_ptr_gray_sync2[ADDR_WIDTH:ADDR_WIDTH-1],
                 rd_ptr_gray_sync2[ADDR_WIDTH-2:0]
            }
        );

        end
    end

    always @(posedge rd_clk or posedge rst)
        begin
            if(rst)
            begin
                rd_ptr_bin  <= 0;
                rd_ptr_gray <= 0;
                data_out    <= 0;
                empty       <= 1'b1;
            end
            else
            begin
                if(rd_en && !empty)
                begin
                    data_out <= mem[rd_ptr_bin[ADDR_WIDTH-1:0]];
                end

                rd_ptr_bin  <= rd_ptr_bin_next;
                rd_ptr_gray <= rd_ptr_gray_next;

                empty <= (rd_ptr_gray_next == wr_ptr_gray_sync2);
            end
        end

    always @(posedge wr_clk or posedge rst)
        begin
            if(rst)
            begin
                rd_ptr_gray_sync1 <= 0;
                rd_ptr_gray_sync2 <= 0;
            end
            else
            begin
                rd_ptr_gray_sync1 <= rd_ptr_gray;
                rd_ptr_gray_sync2 <= rd_ptr_gray_sync1;
            end
        end

    always @(posedge rd_clk or posedge rst)
        begin
            if(rst)
            begin
                wr_ptr_gray_sync1 <= 0;
                wr_ptr_gray_sync2 <= 0;
            end
            else
            begin
                wr_ptr_gray_sync1 <= wr_ptr_gray;
                wr_ptr_gray_sync2 <= wr_ptr_gray_sync1;
            end
        end

endmodule
