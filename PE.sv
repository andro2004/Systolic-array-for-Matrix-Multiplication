module PE #(parameter DATAWIDTH=16,N_SIZE=3)(clk,rst_n,in_h,in_v,pass_outh,pass_outv,out);

localparam out_count_size  = $clog2(N_SIZE);
input [DATAWIDTH-1:0] in_h,in_v;
input clk,rst_n;
output [DATAWIDTH-1:0] pass_outh,pass_outv;
output reg [(2*DATAWIDTH-1):0] out;
//wire [(2*DATAWIDTH-1):0] Add_out;
wire [(2*DATAWIDTH)-1:0] multiplier_out ;
wire [(2*DATAWIDTH)-1:0] adder_input [N_SIZE];

wire [DATAWIDTH-1:0] hreg_in ;
wire [DATAWIDTH-1:0] vreg_in ;
assign hreg_in = in_h;
assign vreg_in = in_v;
temp_register #(DATAWIDTH) hpass_register(hreg_in,pass_outh,clk,rst_n);
temp_register #(DATAWIDTH) voutput_register(vreg_in,pass_outv,clk,rst_n);

multiplier#(DATAWIDTH) MUL (in_h,in_v,multiplier_out);
adder #(DATAWIDTH,N_SIZE)ADD (adder_input,out);
reg [out_count_size:0] out_count;
generate 
genvar i;

	for(i=0;i<N_SIZE;i=i+1) 
	begin :registers
		temp_registers_sequance #(2*DATAWIDTH,i+1) temp_registers_row (multiplier_out,adder_input[i],clk,rst_n);
		
	end

endgenerate
/*
always @(posedge clk,negedge rst_n)begin
    
    if (!rst_n)begin
        out_count <= 0;
        out <= 0;
    end
    else begin
        out_count <= (out_count == N_SIZE+1)? out_count:out_count +1;
        out <= (out_count == N_SIZE+1)? out:Add_out;
    end
end
*/
endmodule







