
`timescale 1ns/1ns

module print_tb();
reg clk,rst_n,push;
reg [7:0] pages;
wire warm, loadpage, printpage;

always #5 clk = ~clk;

initial
begin
clk = 0;
rst_n = 0; 
push = 0;
pages = 0;
#10 assign rst_n = 1;
#20 assign pages = 'd70;
assign push = 1;
#5 assign push = 0;
assign pages = 0;
#600 assign pages = 'd40;
assign push = 1;
#5 assign push = 0;
assign pages = 0;
#600 assign pages = 'd15;
assign push = 1;
#5 assign push = 0;
assign pages = 0; 

end



print MUT(warm,loadpage,printpage,clk,rst_n,push,pages);

endmodule
