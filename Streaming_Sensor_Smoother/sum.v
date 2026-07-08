module sum (
    input  wire [7:0] in0,
    input  wire [7:0] in1,
    input  wire [7:0] in2,
    input  wire [7:0] in3,

    output wire [9:0] sum
);

    // Level 1 : two independent 8-bit + 8-bit adders (run in parallel)
    wire [8:0] sum_a;   // in0 + in1
    wire [8:0] sum_b;   // in2 + in3

    assign sum_a = {1'b0, in0} + {1'b0, in1};
    assign sum_b = {1'b0, in2} + {1'b0, in3};

    // Level 2 : one 9-bit + 9-bit adder combines the two partial sums
    assign sum = {1'b0, sum_a} + {1'b0, sum_b};

endmodule