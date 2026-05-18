module adder #(parameter DATAWIDTH =16,N_SIZE=5) (in,out);

input [(2*DATAWIDTH)-1:0] in[N_SIZE];
output  [(2*DATAWIDTH)-1:0] out;
wire [(2*DATAWIDTH)-1:0] mid_wires [N_SIZE-2];


generate 
genvar i;
	
	for(i=0;i<N_SIZE-1;i=i+1)
	begin:adder
		if (i==0) adder_2in #(DATAWIDTH) add (in[i],in[i+1],mid_wires[i]);
		else if(i==N_SIZE-2) adder_2in #(DATAWIDTH)add (mid_wires[i-1],in[i+1],out);
		else adder_2in #(DATAWIDTH)add (mid_wires[i-1],in[i+1],mid_wires[i]);
	end
	
endgenerate

endmodule

module adder_2in #(parameter DATAWIDTH =16) (in_1,in_2,out);


input [(2*DATAWIDTH)-1:0] in_1,in_2;
output [(2*DATAWIDTH)-1:0] out;

assign out =in_1+in_2;

endmodule