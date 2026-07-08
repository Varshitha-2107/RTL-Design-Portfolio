`timescale 1ns/1ps
module round_robin_tb;
parameter N=4;
reg clk;
reg rst;
reg [N-1:0]req;
wire [N-1:0]grant;
round_robin #(N) uut (.clk(clk),.rst(rst),.req(req),.grant(grant));
always #5 clk=~clk;
initial begin
    $monitor("Time=%0t rst=%0b req=%0b grant=%0b",$time,rst,req,grant);
end
initial begin
    clk=0;
    rst=1;
    req=4'b0000;
    #12;
    rst=0;
    #10;
    req=4'b0000;
    #10;
    req=4'b0001;
    #10;
    req=4'b0101;
    #10;
    req=4'b1111;
    #40;
    req=4'b0110;
    #40;
    req=4'b0000;
    #20;
    $finish;
end
initial begin
    $dumpfile("rr_tb.vcd");
    $dumpvars(0,round_robin_tb);
end
endmodule