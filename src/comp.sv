`timescale 1ns / 1ps

module comp(
    input logic [31:0] a,
    input logic [31:0] b,
    output logic gt,
    output logic eq,
    output logic lt
);

    logic [31:0] eq_prefix, gt_prefix, lt_prefix;

    assign eq_prefix[31] = a[31] ~^ b[31];
    assign gt_prefix[31] = a[31] & ~b[31];
    assign lt_prefix[31] = ~a[31] & b[31];

    genvar i;
    generate
        for (i = 30; i >= 0; i--) begin : comp_chain
            assign eq_prefix[i] = eq_prefix[i+1] & (a[i] ~^ b[i]);
            assign gt_prefix[i] = gt_prefix[i+1] | (eq_prefix[i+1] & a[i] & ~b[i]);
            assign lt_prefix[i] = lt_prefix[i+1] | (eq_prefix[i+1] & ~a[i] & b[i]);
        end
    endgenerate

    assign eq = eq_prefix[0];
    assign gt = gt_prefix[0];
    assign lt = lt_prefix[0];

endmodule
