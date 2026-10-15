module csla_16bit_tb;
    reg [15:0] a, b;
    reg cin;
    wire [15:0] sum;
    wire cout;

    csla_16bit uut (
        .a(a), .b(b), .cin(cin),
        .sum(sum), .cout(cout)
    );

    initial begin
        $dumpfile("dump.vcd");
        
        $dumpvars(0, csla_16bit_tb);
        $monitor("the value of a is %b and b is %b ,cin is %b sum is %b,cout is %b ",a,b,cin, sum,cout);
        // Test Case 1: Simple Addition
        a = 16'h1111; b = 16'h2222; cin = 0; #10;

        // Test Case 2: Alternating bits with carry
        a = 16'hAAAA; b = 16'h5555; cin = 1; #10;

        // Test Case 3: Overflow condition
        a = 16'hFFFF; b = 16'h0001; cin = 0; #10;

        $finish;
    end
endmodule