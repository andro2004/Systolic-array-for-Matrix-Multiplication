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
//wire [(2*DATAWIDTH)-1:0] mux_in [N_SIZE*N_SIZE];

//wire [(2*DATAWIDTH)-1:0] concatenated_cols [N_SIZE][N_SIZE];

wire  [$clog2(N_SIZE)-1:0] sel;
counter #($clog2(N_SIZE)-1) out_control_counter (clk,valid_in,rst_n,sel);

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
		
	end
	
end

endgenerate

endmodule












