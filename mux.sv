module mux #(parameter DATAWIDTH=16,N_SIZE=5) (in,out,sel);


input [(DATAWIDTH*2)-1:0] in [N_SIZE];
input  [$clog2(N_SIZE)-1:0] sel;
output reg [(DATAWIDTH*2)-1:0] out;

always @(*) begin

out=in[sel];


end

endmodule
