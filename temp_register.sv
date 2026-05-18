//Register used for storing data temporarly at the postive edge of the golbal clock signal

module temp_register #(parameter DATAWIDTH=32) (data_in,data_out,clk,rst_n);

//Inputs:
input [DATAWIDTH-1:0] data_in; //input port of size DATAWIDTH for the data to be stored in the register.
input clk;//Golbal clock signal.
input rst_n;//Golbal active low asyncronus reset signal;
//Outputs:
output reg [DATAWIDTH-1:0] data_out;//output port register of size DATAWIDTH to store data.


always @(posedge clk,negedge rst_n) begin //the always block is trigired by the postive edge of the gobal clk cycle and the negtive edge asyncronus reset signal.

//asyncronus reset for the data when the rst_n signal is equal to zero
if(rst_n==0) data_out<=0;
//the ouput port reg stores the data at the postive edge of the golbal clk cycle.
else data_out<=data_in;

end


endmodule