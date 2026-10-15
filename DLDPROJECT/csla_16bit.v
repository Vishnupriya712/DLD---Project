module csla_4bit (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);
    wire [3:0] sum0, sum1;
    wire cout0, cout1;

    // Pre-calculate sum and carry-out for cin = 0
    assign {cout0, sum0} = a + b + 1'b0;

    // Pre-calculate sum and carry-out for cin = 1
    assign {cout1, sum1} = a + b + 1'b1;

    // Multiplexer selects actual outputs based on real cin
    assign sum  = cin ? sum1  : sum0;
    assign cout = cin ? cout1 : cout0;
endmodule


module csla_16bit (
    input [15:0] a,
    input [15:0] b,
    input cin,
    output [15:0] sum,
    output cout
);
    wire [4:0] c;
    assign c[0] = cin;

    // Instantiating 4 blocks of 4-bit Carry Select Adders
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : select_blocks
            csla_4bit block_inst (
                .a(a[4*i +: 4]),
                .b(b[4*i +: 4]),
                .cin(c[i]),
                .sum(sum[4*i +: 4]),
                .cout(c[i+1])
            );
        end
    endgenerate

    assign cout = c[4];
endmodule