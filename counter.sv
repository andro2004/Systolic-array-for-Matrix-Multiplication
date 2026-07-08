module counter #(parameter size=3)(clk,valid_in,rst_n,out);

input clk,rst_n,valid_in;
output reg [size:0]  out;

always @(posedge clk,negedge rst_n) begin

if (rst_n==0 || valid_in == 1) out<= 0;
else out<=out+1;


end

endmodule