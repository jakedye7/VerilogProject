// 55:035 sisc processor project
// part 3 - swap register addresses

`timescale 1ns/100ps

module swap_reg(a_input,b_input, out_sel, data_out);

/**
* SWAP REG REGISTER FILE - swap_reg.v
*Inputs:	
*	-a_input (4bits): Address of RS 
*	-b_input (4bits): Address of RT
*	-out_sel 1 bit: choose which register to output to multiplexer. multiplexer inputs into rf
*		0 -> swap rs; 1-> swap rt
*OUTPUTS:
*	-data_out (4bits): Address of register to be swapped
*/

input [3:0] a_input;
input [3:0] b_input;
input out_sel;

output [3:0] data_out;
reg [3:0] data_out;

always @ (a_input,b_input, out_sel)
begin
	if(out_sel == 1'b0)
	begin
		data_out <= b_input;
	end
	if(out_sel == 1'b1)
	begin
		data_out <= a_input;
	end
end

endmodule
