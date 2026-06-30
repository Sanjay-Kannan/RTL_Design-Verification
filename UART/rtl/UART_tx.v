`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/29/2026 10:38:55 AM
// Design Name: 
// Module Name: UART_tx
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


module uart_tx #(
    parameter integer CLKS_PER_BIT = 434
)(
    input clk,
    input rst,

    input baud_tick,
    input start,

    input [7:0] txin,

    output tx,
    output reg txdone,
    output reg busy
);

    //-------------------------------------------------
    // State Encoding
    //-------------------------------------------------
    localparam IDLE  = 2'd0;
    localparam START = 2'd1;
    localparam DATA  = 2'd2;
    localparam STOP  = 2'd3;

    //-------------------------------------------------
    // Registers
    //-------------------------------------------------
    reg [1:0] state;
    reg [7:0] shift_reg;
    reg [2:0] bit_counter;

    //-------------------------------------------------
    // TX Output Logic
    //-------------------------------------------------
    assign tx = (state == IDLE)  ? 1'b1 :
                (state == START) ? 1'b0 :
                (state == STOP)  ? 1'b1 :
                                   shift_reg[0];

    //-------------------------------------------------
    // FSM
    //-------------------------------------------------
    always @(posedge clk or posedge rst)
    begin
        if(rst)
        begin
            state       <= IDLE;
            shift_reg   <= 8'd0;
            bit_counter <= 3'd0;

            busy        <= 1'b0;
            txdone      <= 1'b0;
        end
        else
        begin

            // Default output
            txdone <= 1'b0;

            case(state)

            //-----------------------------------------
            // IDLE
            //-----------------------------------------
            IDLE:
            begin
                busy <= 1'b0;

                if(start)
                begin
                    shift_reg   <= txin;
                    bit_counter <= 3'd0;
                    busy        <= 1'b1;
                    state       <= START;
                end
            end

            //-----------------------------------------
            // START BIT
            //-----------------------------------------
            START:
            begin
                busy <= 1'b1;

                if(baud_tick)
                begin
                    state <= DATA;
                end
            end

            //-----------------------------------------
            // DATA BITS
            //-----------------------------------------
            DATA:
            begin
                busy <= 1'b1;

                if(baud_tick)
                begin
                    if(bit_counter == 3'd7)
                    begin
                        state <= STOP;
                    end
                    else
                    begin
                        bit_counter <= bit_counter + 1'b1;
                    end

                    shift_reg <= {1'b0, shift_reg[7:1]};
                end
            end

            //-----------------------------------------
            // STOP BIT
            //-----------------------------------------
            STOP:
            begin
                busy <= 1'b1;

                if(baud_tick)
                begin
                    busy   <= 1'b0;
                    txdone <= 1'b1;
                    state  <= IDLE;
                end
            end

            default:
            begin
                state <= IDLE;
            end

            endcase
        end
    end

endmodule