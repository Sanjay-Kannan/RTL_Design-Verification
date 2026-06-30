`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/26/2026 04:08:21 PM
// Design Name: 
// Module Name: digital_alarm_clock
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


module digital_alarm_clock(
    input clk,
    input rst,
    input inc_hour,
    input inc_min,
    input alarm_toggle,
    input mode_btn,
    input stop_btn,
    output [4:0] hours_out,
    output [5:0] minutes_out,
    output [5:0] seconds_out,
    output alarm_match
    );

    wire tick;
    wire carry;
    wire minute_carry;
    wire day_carry;

    wire clock_enable;
    wire buzzer_enable;
    wire set_time_enable;
    wire set_alarm_enable;

    wire [4:0] hours;
    wire [5:0] minutes;
    wire [5:0] seconds;

    wire [4:0] alarm_hour;
    wire [5:0] alarm_min;

    wire alarm_en;

    wire mode_pulse;
    wire stop_pulse;
    wire hour_pulse;
    wire min_pulse;
    wire toggle_pulse;


    button_edge_detector mode_edge(
        .clk(clk),
        .rst(rst),
        .button(mode_btn),
        .pulse(mode_pulse)
    );

    button_edge_detector stop_edge(
        .clk(clk),
        .rst(rst),
        .button(stop_btn),
        .pulse(stop_pulse)
    );

    button_edge_detector hour_edge(
        .clk(clk),
        .rst(rst),
        .button(inc_hour),
        .pulse(hour_pulse)
    );

    button_edge_detector min_edge(
        .clk(clk),
        .rst(rst),
        .button(inc_min),
        .pulse(min_pulse)
    );

    button_edge_detector toggle_edge(
        .clk(clk),
        .rst(rst),
        .button(alarm_toggle),
        .pulse(toggle_pulse)
    );

    clock_divider divider_inst(
        .clk(clk),
        .rst(rst),
        .tick(tick)
    );

    seconds_counter seconds_inst(
    .clk(clk),
    .rst(rst),
    .tick(tick),
    .clock_enable(clock_enable),
    .carry(carry),
    .seconds(seconds)
    );

    minutes_counter minutes_inst(
    .clk(clk),
    .rst(rst),
    .carry(carry),
    .clock_enable(clock_enable),
    .set_time_enable(set_time_enable),
    .minutes(minutes),
    .inc_min(min_pulse),
    .minute_carry(minute_carry)
    );

    hour_counter hour_inst(
    .clk(clk),
    .rst(rst),
    .minute_carry(minute_carry),
    .clock_enable(clock_enable),
    .set_time_enable(set_time_enable),
    .inc_hour(hour_pulse),
    .hours(hours),
    .day_carry(day_carry)
    );

    alarm_register alarm_inst(
    .clk(clk),
    .rst(rst),
    .alarm_toggle(toggle_pulse),
    .set_alarm_enable(set_alarm_enable),
    .alarm_hour(alarm_hour),
    .alarm_min(alarm_min),
    .inc_hour(hour_pulse),
    .inc_min(min_pulse),
    .alarm_en(alarm_en)
    );

    alarm_comparator comparator_inst(
    .current_hour(hours),
    .current_min(minutes),
    .current_sec(seconds),
    .alarm_hour(alarm_hour),
    .alarm_min(alarm_min),
    .alarm_en(alarm_en),
    .alarm_match(alarm_match)
    );

    assign hours_out   = hours;
    assign minutes_out = minutes;
    assign seconds_out = seconds;

    fsm_controller fsm_inst(
    .clk(clk),
    .rst(rst),
    .mode_btn(mode_pulse),
    .stop_btn(stop_pulse),
    .alarm_match(alarm_match), 
    .current_state(),
    .clock_enable(clock_enable),
    .buzzer_enable(buzzer_enable),
    .set_time_enable(set_time_enable),
    .set_alarm_enable(set_alarm_enable)
    );

endmodule
