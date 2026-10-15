module csa_16bit_tb;
    reg [15:0] a, b;
    reg cin;
    wire [15:0] sum;
    wire cout;

    csa_16bit uut (
        .a(a), .b(b), .cin(cin),
        .sum(sum), .cout(cout)
    );

    initial begin
        $dumpfile("dump.vcd");
        
        $dumpvars(0, csa_16bit_tb);
        $monitor("the value of a is %b and b is %b ,cin is %b sum is %b,cout is %b ",a,b,cin, sum,cout);
        
        // Test Case 1: Standard Addition
        a = 16'h1234; b = 16'h4321; cin = 0; #10;

        // Test Case 2: Triggers Carry Skip Logic across all 4 blocks
        a = 16'hFFFF; b = 16'h0000; cin = 1; #10;

        // Test Case 3: Overflow condition
        a = 16'h8000; b = 16'h8000; cin = 0; #10;

        $finish;
    end
endmodule