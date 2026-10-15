module rca_16bit_tb;
    reg [15:0] a;
    reg [15:0] b;
    reg cin;
    wire [15:0] sum;
    wire cout;

    // Instantiate the 16-bit RCA
    rca_16bit uut (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, rca_16bit_tb);  
        $monitor("the value of a is %b and b is %b ,cin is %b sum is %b,cout is %b ",a,b,cin, sum,cout);
        // Test Case 1
        a = 16'h000F; b = 16'h0001; cin = 0; #10;
        
        // Test Case 2
        a = 16'h1234; b = 16'h5678; cin = 0; #10;
        // Test Case 3 (Testing carry propagation)
        a = 16'hFFFF; b = 16'h0001; cin = 0; #10;
        
        $finish;
    end
endmodule