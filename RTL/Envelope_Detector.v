module Envelope_Detector #(
    parameter DATA_WIDTH = 32,
    parameter ALPHA = 16'h00FF       // alpha ? 0.1 in Q1.15 format
)(
    input  wire clk,
    input  wire rst_n,                                   // asynchronous active-low reset
    input  wire signed [DATA_WIDTH-1:0] signal_in,
    output reg  [DATA_WIDTH-1:0] envelope_out
);

    wire [DATA_WIDTH-1:0] abs_signal;
    wire [DATA_WIDTH+15:0] mult1, mult2;
    reg  [DATA_WIDTH+15:0] filtered;
    reg  [DATA_WIDTH-1:0] env_prev;

    // Absolute value
    assign abs_signal = (signal_in < 0) ? -signal_in : signal_in;

    // Multiply in Q1.15
    assign mult1 = env_prev * (16'hFFFF - ALPHA);
    assign mult2 = abs_signal * ALPHA;

    // Envelope calculation with asynchronous reset
    always @(posedge clk or posedge rst_n) begin
        if (!rst_n) begin
            envelope_out <= 0;
            env_prev     <= 0;
            filtered     <= 0;
        end else begin
            filtered     <= mult1 + mult2;
            envelope_out <= filtered[DATA_WIDTH+14:15];
            env_prev     <= envelope_out;
        end
    end
endmodule
