module csa_4bit (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);
    wire [4:0] c;
    wire [3:0] p;
    wire block_p;

    assign c[0] = cin;

    // Standard ripple carry logic for 4 bits
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : fa_loop
            assign sum[i] = a[i] ^ b[i] ^ c[i];
            assign c[i+1] = (a[i] & b[i]) | (a[i] & c[i]) | (b[i] & c[i]);
            assign p[i]   = a[i] ^ b[i]; // Bitwise propagate
        end
    endgenerate

    // Block Propagate = 1 if ALL bits in the 4-bit group propagate
    assign block_p = &p; 

    // Skip Multiplexer: 
    // If block_p is high, skip the ripple carry (c[4]) and send 'cin' directly to 'cout'
    assign cout = block_p ? cin : c[4];
endmodule

module csa_16bit (
    input [15:0] a,
    input [15:0] b,
    input cin,
    output [15:0] sum,
    output cout
);
    wire [4:0] c;
    assign c[0] = cin;

    // Instantiating 4 blocks of 4-bit Carry Skip Adders
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : skip_blocks
            csa_4bit block_inst (
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