`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/29/2026 03:14:49 PM
// Design Name: 
// Module Name: uart_rx
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


module uart_rx #(parameter integer CLKS_PER_BIT = 434)(
    input clk,
    input rst,
    input rx,
    output reg [7:0] data_out,
    output reg rx_done,
    output reg busy,
    output reg framing_error
    );

    reg [7:0] shift_reg;
    reg [2:0] bit_counter;
    reg [$clog2(CLKS_PER_BIT)-1:0] baud_counter;
    reg [2:0] state;
    reg rx_prev;

    localparam IDLE  = 3'd0;
    localparam START = 3'd1;
    localparam DATA  = 3'd2;
    localparam STOP  = 3'd3;
    localparam DONE  = 3'd4;
    localparam ERROR = 3'd5;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            state <= IDLE;
            shift_reg <= 8'd0;
            bit_counter <= 3'd0;
            baud_counter <= 0;
            rx_prev <= 1'b1;
            data_out <= 8'd0;
            rx_done <= 1'b0;
            busy <= 1'b0;
            framing_error <= 1'b0;
        end
        else begin
            rx_prev <= rx;

            rx_done <= 1'b0;

            case (state)
               IDLE : begin
                busy <= 1'b0;
                baud_counter <= 0;
                bit_counter <= 0;
                if(rx_prev && !rx)
                    state <= START;
               end

               START : begin
                baud_counter <= baud_counter + 1'b1;
                if(baud_counter == CLKS_PER_BIT/2 - 1) begin
                    if(rx == 1'b0) begin
                        busy <= 1'b1;
                        baud_counter <= 0;
                        bit_counter <= 0;
                        state <= DATA;
                    end
                    else begin
                        baud_counter <= 0;
                        state <= IDLE;
                    end
                end
               end

               DATA : begin
                busy <= 1'b1;
                baud_counter <= baud_counter + 1'b1;
                if(baud_counter == CLKS_PER_BIT - 1) begin
                    shift_reg[bit_counter] <= rx;
                    baud_counter <= 0;
                    if(bit_counter < 7)
                        bit_counter <= bit_counter + 1;
                    else begin
                        baud_counter <= 0;
                        state <= STOP;  
                    end
                end
               end

               STOP : begin
                busy <= 1'b1;
                baud_counter <= baud_counter + 1'b1;
                if (baud_counter == CLKS_PER_BIT - 1) begin
                    if(rx == 1) begin
                        data_out <= shift_reg;
                        state <= DONE;
                        baud_counter <= 0;
                        framing_error <= 1'b0;
                    end
                    else begin
                        framing_error <= 1'b1;
                        state <= ERROR;
                        baud_counter <= 0;
                    end
                end
               end

               DONE : begin
                busy <= 1'b0;
                rx_done <= 1'b1;
                state <= IDLE;
               end

               ERROR : begin
                busy <= 1'b0;
                state <= IDLE;
               end
                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule
