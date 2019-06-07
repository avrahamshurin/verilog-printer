

module print(warm,loadpage,printpage, clk,rst_n,push,pages);
  
input clk,rst_n,push;
input [7:0] pages;
output reg warm, loadpage, printpage;

reg [7:0] pages_to_print;
reg [6:0] warming_counter;
reg [1:0] current, next;

localparam SLEEPING = 2'b00, WARMING = 2'b01, LOADING = 2'b10, PRINTING = 2'b11;

always @ (current, push, warming_counter, pages_to_print)
case(current)
	SLEEPING:	if (push) next = WARMING;
		else next = SLEEPING;	
	WARMING:	if (warming_counter == 'd100) next = LOADING;
		else next = WARMING;	
	LOADING:	next =PRINTING;
	PRINTING:	if (pages_to_print) next = LOADING;
		else next = SLEEPING;	
endcase

always @(negedge rst_n,posedge clk)
begin
if (!rst_n)
begin current <= SLEEPING;
end
else current <= next;
end


always @(negedge rst_n, posedge clk)
begin
if (!rst_n)
warming_counter <=0;
else if (current == WARMING)
warming_counter <= warming_counter+1;
else if (current == SLEEPING)
warming_counter <= 0;   
end

always @(posedge clk)
begin
if (!rst_n) 
pages_to_print <=0; 
else if (current == PRINTING) if (next != SLEEPING)
pages_to_print <= pages_to_print - 1;
else if (next == SLEEPING)
pages_to_print <= 0;   
end

always @(posedge push)
pages_to_print <= pages_to_print + pages;


always @(current) 
case(current)
  SLEEPING:begin warm = 0;
            loadpage = 0;
            printpage =0;
            end
  WARMING:begin warm = 1;
            loadpage = 0;
            printpage =0;
            end
  LOADING:begin warm = 0;
            loadpage = 1;
            printpage =0;
          end
  PRINTING:begin warm = 0;
            loadpage = 0; 
            printpage =1;
          end
endcase


endmodule
