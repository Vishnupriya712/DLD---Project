module cla_4bit (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output pg,  // Group Propagate
    output gg   // Group Generate
);
    wire [3:0] p, g;
    wire [3:1] c;

    // Bitwise Propagate and Generate
    assign p = a ^ b;
    assign g = a & b;

    // Parallel Carry Equations inside the 4-bit block
    assign c[1] = g[0] | (p[0] & cin);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & cin);

    // Final Sum
    assign sum = p ^ {c[3:1], cin};

    // Block/Group-level Propagate and Generate logic
    assign pg = &p; // All 4 bits propagate
    assign gg = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
endmodule

module lcu_4bit (
    input [3:0] pg,
    input [3:0] gg,
    input cin,
    output [4:1] c
);
    assign c[1] = gg[0] | (pg[0] & cin);
    assign c[2] = gg[1] | (pg[1] & gg[0]) | (pg[1] & pg[0] & cin);
    assign c[3] = gg[2] | (pg[2] & gg[1]) | (pg[2] & pg[1] & gg[0]) | (pg[2] & pg[1] & pg[0] & cin);
    assign c[4] = gg[3] | (pg[3] & gg[2]) | (pg[3] & pg[2] & gg[1]) | (pg[3] & pg[2] & pg[1] & gg[0]) | (pg[3] & pg[2] & pg[1] & pg[0] & cin);
endmodule


module cla_16bit (
    input [15:0] a,
    input [15:0] b,
    input cin,
    output [15:0] sum,
    output cout
);
    wire [3:0] pg, gg;
    wire [4:0] c;

    assign c[0] = cin;

    // Instantiate 4-bit CLA blocks
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : cla_blocks
            cla_4bit block_inst (
                .a(a[4*i +: 4]),
                .b(b[4*i +: 4]),
                .cin(c[i]),
                .sum(sum[4*i +: 4]),
                .pg(pg[i]),
                .gg(gg[i])
            );
        end
    endgenerate

    // Lookahead Carry Unit across the 4 blocks
    lcu_4bit lcu_inst (
        .pg(pg),
        .gg(gg),
        .cin(cin),
        .c(c[4:1])
    );

    assign cout = c[4];
endmodule