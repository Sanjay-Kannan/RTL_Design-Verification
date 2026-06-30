`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/30/2026 01:18:25 PM
// Design Name: 
// Module Name: fifio
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


module fifo_sync #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 16
)(
    input clk,
    input rst,
    input wr_en,
    input rd_en,
    input [DATA_WIDTH -1:0]data_in,
    output reg [DATA_WIDTH -1:0]data_out,
    output full,
    output empty
    );

    reg [DATA_WIDTH-1:0] mem[0:DEPTH-1];

    localparam ADDR_WIDTH = $clog2(DEPTH);

    reg [ADDR_WIDTH-1:0] wr_ptr;
    reg [ADDR_WIDTH-1:0] rd_ptr;

    reg [ADDR_WIDTH:0] count;

    assign empty = (count == 0);
    assign full = (count == DEPTH);

    always @(posedge clk) begin
        if(rst) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            count <= 0;
            data_out <= 0;
        end
        else begin
            if(wr_en && !rd_en && !full) begin
                mem[wr_ptr] <= data_in;
                if (wr_ptr == DEPTH - 1)
                    wr_ptr <= 0;
                else 
                    wr_ptr <= wr_ptr + 1'b1;
                count <= count + 1'b1;
                
            end
            else if (rd_en && !wr_en && !empty) begin
                data_out <= mem[rd_ptr];
                count <= count - 1'b1;
                if (rd_ptr == DEPTH - 1) 
                    rd_ptr <= 0;
                else
                    rd_ptr <= rd_ptr + 1'b1;
            end
            else if (wr_en && rd_en && !empty) begin
                mem[wr_ptr] <= data_in;
                data_out <= mem[rd_ptr];
                if (wr_ptr == DEPTH - 1)
                    wr_ptr <= 0;
                else 
                    wr_ptr <= wr_ptr + 1'b1;
                if (rd_ptr == DEPTH - 1) 
                    rd_ptr <= 0;
                else
                    rd_ptr <= rd_ptr + 1'b1;
            end
            else if (rd_en && wr_en && empty) begin
                mem[wr_ptr] <= data_in;
                if (wr_ptr == DEPTH - 1)
                    wr_ptr <= 0;
                else 
                    wr_ptr <= wr_ptr + 1'b1;
                count <= count + 1'b1;
            end
        end
    end

endmodule
