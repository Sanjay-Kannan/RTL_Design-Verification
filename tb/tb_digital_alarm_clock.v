`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/26/2026 04:40:11 PM
// Design Name: 
// Module Name: tb_digital_alarm_clock
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


`timescale 1ns/1ps

module tb_digital_alarm_clock;

reg clk;
reg rst;

reg inc_hour;
reg inc_min;
reg alarm_toggle;
reg mode_btn;
reg stop_btn;

wire [4:0] hours_out;
wire [5:0] minutes_out;
wire [5:0] seconds_out;
wire alarm_match;

digital_alarm_clock dut(
    .clk(clk),
    .rst(rst),
    .inc_hour(inc_hour),
    .inc_min(inc_min),
    .alarm_toggle(alarm_toggle),
    .mode_btn(mode_btn),
    .stop_btn(stop_btn),
    .hours_out(hours_out),
    .minutes_out(minutes_out),
    .seconds_out(seconds_out),
    .alarm_match(alarm_match)
);

always #5 clk = ~clk;

//////////////////////////////////////////////////
// Button Tasks
//////////////////////////////////////////////////

task press_mode;
begin
    @(negedge clk);
    mode_btn = 1;
    @(negedge clk);
    mode_btn = 0;
end
endtask

task press_hour;
begin
    @(negedge clk);
    inc_hour = 1;
    @(negedge clk);
    inc_hour = 0;
end
endtask

task press_minute;
begin
    @(negedge clk);
    inc_min = 1;
    @(negedge clk);
    inc_min = 0;
end
endtask

task toggle_alarm;
begin
    @(negedge clk);
    alarm_toggle = 1;
    @(negedge clk);
    alarm_toggle = 0;
end
endtask

task press_stop;
begin
    @(negedge clk);
    stop_btn = 1;
    @(negedge clk);
    stop_btn = 0;
end
endtask

//////////////////////////////////////////////////
// Monitor
//////////////////////////////////////////////////

initial begin

// $monitor(
// "T=%0t | Time=%02d:%02d:%02d | Alarm=%02d:%02d | En=%b | Match=%b",
// $time,
// hours_out,
// minutes_out,
// seconds_out,
// dut.alarm_hour,
// dut.alarm_min,
// dut.alarm_en,
// alarm_match
// );

$monitor(
"T=%0t | State=%b | Time=%02d:%02d:%02d | Alarm=%02d:%02d | En=%b | Match=%b | ClockEn=%b | SetTime=%b | SetAlarm=%b | Buzzer=%b",
$time,
dut.fsm_inst.current_state,
hours_out,
minutes_out,
seconds_out,
dut.alarm_hour,
dut.alarm_min,
dut.alarm_en,
alarm_match,
dut.clock_enable,
dut.set_time_enable,
dut.set_alarm_enable,
dut.buzzer_enable
);

end

//////////////////////////////////////////////////
// Test Sequence
//////////////////////////////////////////////////

initial begin

clk = 0;
rst = 1;

inc_hour = 0;
inc_min = 0;
alarm_toggle = 0;
mode_btn = 0;
stop_btn = 0;

//////////////////////////////
// Reset
//////////////////////////////

#20;
rst = 0;

//////////////////////////////
// Let clock run
//////////////////////////////

repeat(5) @(posedge clk);

//////////////////////////////
// SET_ALARM
//////////////////////////////

press_mode();      // SHOW_TIME -> SET_TIME
press_mode();      // SET_TIME -> SET_ALARM

//////////////////////////////
// Alarm = 00:01
//////////////////////////////

press_minute();

//////////////////////////////
// Enable Alarm
//////////////////////////////

toggle_alarm();

//////////////////////////////
// Back to SHOW_TIME
//////////////////////////////

press_mode();

//////////////////////////////
// Wait until alarm time
//////////////////////////////

repeat(80) @(posedge clk);

//////////////////////////////
// Stop Alarm
//////////////////////////////

press_stop();

repeat(20) @(posedge clk);

$display("\nSimulation Finished\n");

$finish;

end

endmodule
