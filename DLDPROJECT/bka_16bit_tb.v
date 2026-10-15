module bka_16bit_tb;
    reg [15:0] a, b;
    reg cin;
    wire [15:0] sum;
    wire cout;

    bka_16bit uut (
        .a(a), .b(b), .cin(cin),
        .sum(sum), .cout(cout)
    );

    initial begin
        $dumpfile("dump.vcd");
        
        $dumpvars(0, csa_16bit_tb);
        $monitor("the value of a is %b and b is %b ,cin is %b sum is %b,cout is %b ",a,b,cin, sum,cout);
        // Test Case 1: Standard Addition
        a = 16'h1234; b = 16'h4321; cin = 0; #10;

        // Test Case 2: Carry Propagation across all bits
        a = 16'hFFFF; b = 16'h0001; cin = 0; #10;

        // Test Case 3: Pattern test
        a = 16'h0F0F; b = 16'hF0F0; cin = 1; #10;

        $finish;
    end
endmodule