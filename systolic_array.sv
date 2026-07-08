module systolic_array #(parameter DATAWIDTH=16,N_SIZE=3) (clk,rst_n,valid_in,matrix_a_in,matrix_b_in,valid_out,matrix_c_out);

input clk,rst_n,valid_in;
input [DATAWIDTH-1:0] matrix_a_in [N_SIZE];
input [DATAWIDTH-1:0] matrix_b_in [N_SIZE];
output valid_out;
output [(2*DATAWIDTH)-1:0] matrix_c_out [N_SIZE];
wire [DATAWIDTH-1:0] PE_inh[N_SIZE*N_SIZE];
wire [DATAWIDTH-1:0] PE_inv[N_SIZE*N_SIZE];
wire [DATAWIDTH-1:0] PE_outh[N_SIZE*N_SIZE];
wire [DATAWIDTH-1:0] PE_outv[N_SIZE*N_SIZE];
wire [(2*DATAWIDTH)-1:0] PE_OUT [N_SIZE*N_SIZE];
wire [(2*DATAWIDTH)-1:0] PE_reg_OUT [N_SIZE*N_SIZE];
wire [(2*DATAWIDTH)-1:0] Mux_in [N_SIZE][N_SIZE];
wire  [N_SIZE:0] counter_out;
counter #(N_SIZE) out_control_counter 
         (.clk(clk),.valid_in(valid_in),.rst_n(rst_n),.out(counter_out));
assign valid_out = ((counter_out>=N_SIZE-1) && (counter_out<=2*(N_SIZE-1)));
generate 
genvar i,j,m;

for(i=0;i<N_SIZE;i=i+1)
begin:Row
	if (i!=0)
	temp_registers_sequance #(DATAWIDTH,i) temp_registers_row (matrix_a_in[i],PE_inh[i*N_SIZE],clk,rst_n);
	for(j=0;j<N_SIZE;j=j+1) 
	begin:Col
		localparam int element_number = (i * N_SIZE) + j;
		if(i==0&&j!=0) temp_registers_sequance #(DATAWIDTH,j) temp_registers_col (matrix_b_in[j],PE_inv[j],clk,rst_n);
	   
		if (i==0 && j==0) begin assign PE_inh[element_number] = matrix_a_in[i] ; assign PE_inv[element_number] =matrix_b_in[i]; end
		else if (i==0&& j!=0)  assign PE_inh[element_number] = PE_outh[element_number-1] ;
		else if (j==0&& i!=0)  assign PE_inv[element_number] =PE_outv[element_number-N_SIZE] ; 
		else if (i!=0&& j!=0) begin assign PE_inh[element_number] = PE_outh[element_number-1] ; assign PE_inv[element_number] =PE_outv[element_number-N_SIZE] ; end
		
		PE #(DATAWIDTH,N_SIZE) pe (clk,rst_n,PE_inh[element_number],PE_inv[element_number],PE_outh[element_number],PE_outv[element_number],PE_OUT[element_number]);
		if(N_SIZE-1-i !=0)begin
		  temp_registers_sequance#(.DATAWIDTH(DATAWIDTH*2),.REG_COUNT(N_SIZE-1-i))PE_OUT_REG
		  (.data_in(PE_OUT[element_number]),.data_out(PE_reg_OUT[element_number]),.clk(clk),.rst_n(rst_n));
		end
		else begin
		  assign PE_reg_OUT[element_number] = PE_OUT[element_number];
		end
		assign Mux_in[i][j] = PE_reg_OUT[element_number];
	end
	
	for(m=0;m<N_SIZE;m=m+1)begin:MUX_OUT
	   mux #(.DATAWIDTH(DATAWIDTH),.N_SIZE(N_SIZE)) mux_out
        (.in(Mux_in[m]),.out(matrix_c_out[m]),.sel(counter_out-(N_SIZE-1)));
	end
	
end
endgenerate
endmodule












