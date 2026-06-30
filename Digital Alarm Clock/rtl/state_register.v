`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/26/2026 05:29:47 PM
// Design Name: 
// Module Name: state_register
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


module fsm_controller(
    input wire clk,
    input wire rst,
    input mode_btn,
    input stop_btn,
    input wire alarm_match, 
    output reg [1:0] current_state,
    output reg clock_enable,
    output reg buzzer_enable,
    output reg set_time_enable,
    output reg set_alarm_enable
);

    reg [1:0] next_state;

    parameter SHOW_TIME     = 2'b00;
    parameter SET_TIME      = 2'b01;
    parameter SET_ALARM     = 2'b10;
    parameter ALARM_RINGING = 2'b11;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= SHOW_TIME;
        end else begin
            current_state <= next_state; 
        end
    end


    always @(*) begin
        next_state = current_state;
        case (current_state)
            SHOW_TIME : begin if (mode_btn) 
                            next_state = SET_TIME;
                        else if(alarm_match)
                            next_state = ALARM_RINGING;
            end
            
            SET_TIME : begin if(mode_btn)
                            next_state = SET_ALARM;
            end
            
            SET_ALARM : begin if (mode_btn)
                            next_state = SHOW_TIME;
            end

            ALARM_RINGING : begin if(stop_btn)
                                next_state = SHOW_TIME;
            end
        
            default: next_state = SHOW_TIME;
        endcase
    end

    always @(*) begin
        clock_enable = 0;
        buzzer_enable = 0;
        set_time_enable = 0;
        set_alarm_enable = 0;
        case (current_state)
           SHOW_TIME : begin
                            clock_enable = 1;
           end 

           SET_TIME : begin
                            set_time_enable = 1;
           end 
           SET_ALARM : begin
                            clock_enable = 1;
                            set_alarm_enable = 1;
           end 
           ALARM_RINGING : begin
                            clock_enable = 1;
                            buzzer_enable = 1;
           end 
            default: begin
                            clock_enable = 1;
           end 
        endcase
    end


endmodule
