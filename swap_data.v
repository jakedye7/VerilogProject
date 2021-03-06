// 55:035 sisc processor project
// part 3 - swap data registers

`timescale 1ns/100ps

module swap_data(a_input,b_input, out_sel, swap_en, data_out);

/**
* SWAP DATA REGISTER FILE - swap_data.v
*Inputs:	
*	-a_input (32bits): Data to be swapped from RS 
*	-b_input (32bits): Data to be swapped from RT
*	-out_sel 1 bit: choose which register to output to multiplexer. multiplexer inputs into rf
*		0 -> swap rs; 1-> swap rt
*OUTPUTS:
*	-data_out (32bits): Data chosen to be swapped
*/

input [31:0] a_input;
input [31:0] b_input;
input out_sel;
input swap_en;

reg[31:0] a_reg;
reg[31:0] b_reg;

output [31:0] data_out;
reg [31:0] data_out;

always @ (out_sel)
begin
	if(out_sel == 1'b1)
	begin
		assign data_out = b_reg;
	end
	if(out_sel == 1'b0)
	begin
		assign data_out = a_reg;
	end
end

always @(swap_en)
begin 
	if(swap_en == 1)
	begin
		a_reg<=a_input;
		b_reg<=b_input;
	end
end

endmodule
