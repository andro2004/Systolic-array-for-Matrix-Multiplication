module counter #(parameter size=2)(clk,valid_in,rst_n,out);

input clk,rst_n,valid_in;
output reg [size-1:0]  out;

wire valid_clk = (~valid_in)&&clk;

always @(posedge valid_clk,negedge rst_n) begin

if (rst_n==0) out<= 0;
else out<=out+1;


end

endmodule