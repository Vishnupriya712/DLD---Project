module full_adder(input a,b,cin,output sum,cout);
   assign sum=a^b^cin;
   assign cout=(a&b) |(a&cin) |(b&cin);
endmodule

module rca_16bit(
    input [15:0] a,
    input [15:0] b,
    input cin,
    output [15:0] sum,
    output cout

);  //internal carry wires connecting the 16 full adders
    wire[16:0]c;
    assign c[0]=cin; //initial carry in
    // istantiate 16 full adders using a generate loop
    genvar i;
    generate
        for (i=0; i<16;i=i+1) begin: fa_chain
            full_adder fa_inst ( .a(a[i]), .b(b[i]), .cin(c[i]), .sum(sum[i]), .cout(c[i+1]));
        end
    endgenerate
    assign cout=c[16];// final global carry output

endmodule

