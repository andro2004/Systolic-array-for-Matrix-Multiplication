module multiplier #(parameter DATAWIDTH =16) (in_1,in_2,out);

input [DATAWIDTH-1:0] in_1,in_2;
output [(2*DATAWIDTH)-1:0] out;

assign out=in_1*in_2;

endmodule