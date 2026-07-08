module mux #(parameter DATAWIDTH=16,N_SIZE=3) (in,out,sel);


input [(DATAWIDTH*2)-1:0] in [N_SIZE];
input  [$clog2(N_SIZE)-1:0] sel;
output [(DATAWIDTH*2)-1:0] out;
assign out=in[sel];

endmodule

/*
module mux #(parameter DATAWIDTH=16,N_SIZE=3) (in,out,sel,clk,rst_n);


input clk,rst_n;
input [(DATAWIDTH*2)-1:0] in [N_SIZE];
input  [$clog2(N_SIZE)-1:0] sel;
output [(DATAWIDTH*2)-1:0] out;
wire [(DATAWIDTH*2)-1:0] regs_out [N_SIZE];
generate
    genvar i;
    for(i=0; i<N_SIZE;i +=1)
    begin
        if(i!=N_SIZE-1)
        begin
            temp_registers_sequance#(.DATAWIDTH(DATAWIDTH*2),.REG_COUNT(N_SIZE-1-i))in_temp_regs
            (.data_in(in[i]),.data_out(regs_out[i]),.clk(clk),.rst_n(rst_n));
        end
        else
            assign regs_out[i] = in[i];
    end
endgenerate 

    assign out=regs_out[sel];

endmodule
*/