`timescale 1ns/1ps

module avg_filter_tb;

    reg         clk;
    reg         rst_n;
    reg  [7:0]  sample_in;
    reg         valid_in;
    wire [7:0]  filt_out;
    wire        valid_out;

    integer     i;
    integer     mismatch_count;

    reg [7:0] ref_tap0, ref_tap1, ref_tap2, ref_tap3;
    reg [2:0] ref_loaded_cnt;
    reg [9:0] ref_sum;
    reg [7:0] ref_filt_out;
    reg       ref_valid_out;

    avg_filter dut (
        .clk        (clk),
        .rst_n      (rst_n),
        .sample_in  (sample_in),
        .valid_in   (valid_in),
        .filt_out   (filt_out),
        .valid_out  (valid_out)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("avg_filter_tb.vcd");
        $dumpvars(0, avg_filter_tb);
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            ref_tap0       <= 8'd0;
            ref_tap1       <= 8'd0;
            ref_tap2       <= 8'd0;
            ref_tap3       <= 8'd0;
            ref_loaded_cnt <= 3'd0;
        end else if (valid_in) begin
            ref_tap3       <= ref_tap2;
            ref_tap2       <= ref_tap1;
            ref_tap1       <= ref_tap0;
            ref_tap0       <= sample_in;
            if (ref_loaded_cnt < 3'd4)
                ref_loaded_cnt <= ref_loaded_cnt + 3'd1;
        end
    end

    always @(negedge clk) begin
        ref_sum       = ref_tap0 + ref_tap1 + ref_tap2 + ref_tap3;
        ref_filt_out  = ref_sum >> 2;
        ref_valid_out = (ref_loaded_cnt == 3'd4);

        if (rst_n) begin
            if ((filt_out !== ref_filt_out) || (valid_out !== ref_valid_out)) begin
                mismatch_count = mismatch_count + 1;
                $display("MISMATCH @ t=%0t : sample_in=%0d valid_in=%0b | DUT(filt=%0d,valid=%0b)  EXPECTED(filt=%0d,valid=%0b)",
                          $time, sample_in, valid_in, filt_out, valid_out, ref_filt_out, ref_valid_out);
            end
        end
    end

    initial begin
        mismatch_count = 0;
        rst_n     = 1'b0;
        sample_in = 8'd0;
        valid_in  = 1'b0;

        repeat (2) @(negedge clk);
        rst_n = 1'b1;

        // 1) Ramp: 0..15
        for (i = 0; i < 16; i = i + 1) begin
            @(negedge clk);
            sample_in = i;
            valid_in  = 1'b1;
        end

        // 2) Step: hold 100 for 6 cycles
        for (i = 0; i < 6; i = i + 1) begin
            @(negedge clk);
            sample_in = 8'd100;
            valid_in  = 1'b1;
        end

        // 3) Gap: valid_in low, DUT must hold state
        for (i = 0; i < 3; i = i + 1) begin
            @(negedge clk);
            sample_in = 8'd200; // must be ignored
            valid_in  = 1'b0;
        end

        // 4) Pseudo-random samples
        for (i = 0; i < 20; i = i + 1) begin
            @(negedge clk);
            sample_in = $random;
            valid_in  = 1'b1;
        end

        @(negedge clk);
        valid_in = 1'b0;
        repeat (3) @(negedge clk);

        if (mismatch_count == 0)
            $display("\n*** TEST PASSED: filt_out/valid_out matched the behavioral reference on every cycle ***\n");
        else
            $display("\n*** TEST FAILED: %0d mismatch(es) detected (see log above) ***\n", mismatch_count);

        $finish;
    end

endmodule