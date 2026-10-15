// Black Cell: Computes both Group Generate and Group Propagate
module black_cell (
    input g_self, p_self,
    input g_prev, p_prev,
    output g_out, p_out
);
    assign g_out = g_self | (p_self & g_prev);
    assign p_out = p_self & p_prev;
endmodule

// Grey Cell: Computes Group Generate only
module grey_cell (
    input g_self, p_self,
    input g_prev,
    output g_out
);
    assign g_out = g_self | (p_self & g_prev);
endmodule


module ksa_16bit (
    input [15:0] a,
    input [15:0] b,
    input cin,
    output [15:0] sum,
    output cout
);
    // Stage 0: Initial P & G
    wire [15:0] p0, g0;
    assign p0 = a ^ b;
    assign g0 = a & b;

    // Stage 1 (Stride = 1)
    wire [15:0] p1, g1;
    assign p1[0] = p0[0];
    assign g1[0] = g0[0];
    genvar i;
    generate
        for (i = 1; i < 16; i = i + 1) begin : stage1
            black_cell bc1 (.g_self(g0[i]), .p_self(p0[i]), .g_prev(g0[i-1]), .p_prev(p0[i-1]), .g_out(g1[i]), .p_out(p1[i]));
        end
    endgenerate

    // Stage 2 (Stride = 2)
    wire [15:0] p2, g2;
    assign p2[1:0] = p1[1:0];
    assign g2[1:0] = g1[1:0];
    generate
        for (i = 2; i < 16; i = i + 1) begin : stage2
            black_cell bc2 (.g_self(g1[i]), .p_self(p1[i]), .g_prev(g1[i-2]), .p_prev(p1[i-2]), .g_out(g2[i]), .p_out(p2[i]));
        end
    endgenerate

    // Stage 3 (Stride = 4)
    wire [15:0] p3, g3;
    assign p3[3:0] = p2[3:0];
    assign g3[3:0] = g2[3:0];
    generate
        for (i = 4; i < 16; i = i + 1) begin : stage3
            black_cell bc3 (.g_self(g2[i]), .p_self(p2[i]), .g_prev(g2[i-4]), .p_prev(p2[i-4]), .g_out(g3[i]), .p_out(p3[i]));
        end
    endgenerate

    // Stage 4 (Stride = 8)
    wire [15:0] p4, g4;
    assign p4[7:0] = p3[7:0];
    assign g4[7:0] = g3[7:0];
    generate
        for (i = 8; i < 16; i = i + 1) begin : stage4
            black_cell bc4 (.g_self(g3[i]), .p_self(p3[i]), .g_prev(g3[i-8]), .p_prev(p3[i-8]), .g_out(g4[i]), .p_out(p4[i]));
        end
    endgenerate

    // Carry evaluation incorporating Cin
    wire [16:0] c;
    assign c[0] = cin;
    generate
        for (i = 0; i < 16; i = i + 1) begin : carry_gen
            assign c[i+1] = g4[i] | (p4[i] & cin);
        end
    endgenerate

    // Post-processing: Final Sum & Carry Out
    assign sum = p0 ^ c[15:0];
    assign cout = c[16];
endmodule