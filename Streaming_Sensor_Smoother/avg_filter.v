module avg_filter (
    input  wire       clk,
    input  wire        rst_n,      // active-low synchronous reset
    input  wire [7:0]  sample_in,
    input  wire         valid_in,

    output wire [7:0]  filt_out,
    output wire         valid_out
);

    wire [7:0] tap0, tap1, tap2, tap3;

    sample_shift_reg u_shift_reg (
        .clk        (clk),
        .rst_n      (rst_n),
        .shift_en   (valid_in),
        .sample_in  (sample_in),
        .tap0       (tap0),
        .tap1       (tap1),
        .tap2       (tap2),
        .tap3       (tap3)
    );

    wire [9:0] sum_total;

    sum u_sum (
        .in0 (tap0),
        .in1 (tap1),
        .in2 (tap2),
        .in3 (tap3),
        .sum (sum_total)
    );

    // Divide-by-4 : right shift by 2 (NO divider hardware)
    assign filt_out = sum_total[9:2];

    // Startup tracking / valid_out
    reg [2:0] loaded_cnt;   // saturates at 4, counts real samples shifted in

    always @(posedge clk) begin
        if (!rst_n) begin
            loaded_cnt <= 3'd0;
        end else if (valid_in && (loaded_cnt < 3'd4)) begin
            loaded_cnt <= loaded_cnt + 3'd1;
        end
    end

    assign valid_out = (loaded_cnt == 3'd4);

endmodule