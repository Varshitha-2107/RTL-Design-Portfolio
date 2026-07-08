module sample_shift_reg (
    input  wire       clk,
    input  wire        rst_n,      // active-low synchronous reset
    input  wire        shift_en,   // = valid_in : only shift on a real sample
    input  wire [7:0]  sample_in,

    output wire [7:0]  tap0,       // x[n]
    output wire [7:0]  tap1,       // x[n-1]
    output wire [7:0]  tap2,       // x[n-2]
    output wire [7:0]  tap3        // x[n-3]
);

    reg [7:0] tap0_r;
    reg [7:0] tap1_r;
    reg [7:0] tap2_r;
    reg [7:0] tap3_r;

    always @(posedge clk) begin
        if (!rst_n) begin
            tap0_r <= 8'd0;
            tap1_r <= 8'd0;
            tap2_r <= 8'd0;
            tap3_r <= 8'd0;
        end else if (shift_en) begin
            tap3_r <= tap2_r;    // x[n-3] <= old x[n-2]
            tap2_r <= tap1_r;    // x[n-2] <= old x[n-1]
            tap1_r <= tap0_r;    // x[n-1] <= old x[n]
            tap0_r <= sample_in; // x[n]   <= new sample
        end
        // else (shift_en == 0): hold current values, no new sample to shift in
    end

    assign tap0 = tap0_r;
    assign tap1 = tap1_r;
    assign tap2 = tap2_r;
    assign tap3 = tap3_r;

endmodule