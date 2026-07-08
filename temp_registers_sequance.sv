module temp_registers_sequance#(parameter DATAWIDTH=32,REG_COUNT=3) (data_in,data_out,clk,rst_n);

input clk,rst_n;
input [DATAWIDTH-1:0] data_in;

output [DATAWIDTH-1:0] data_out;

wire [DATAWIDTH-1:0] regs_out[REG_COUNT+1];
assign data_out = regs_out[REG_COUNT-1];

generate 
genvar i;
	for(i=0;i<REG_COUNT;i=i+1)
	begin:regs
		if(i==0)
			temp_register #(DATAWIDTH) temp_reg (data_in,regs_out[i],clk,rst_n);
		else
			temp_register #(DATAWIDTH) temp_reg (regs_out[i-1],regs_out[i],clk,rst_n);
	end

endgenerate

endmodule 