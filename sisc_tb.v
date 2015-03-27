// 55:035 sisc processor project
// test bench for sisc processor

`timescale 1ns/100ps

module sisc_tb;
	wire CLK, RST_F;
	wire[31:0] IR;

	sisc a(CLK, RST_F, IR);
	sisc_test b(CLK, RST_F, IR);
endmodule

module sisc_test(CLK, RST_F, IR);
	output CLK, RST_F;
	output[31:0] IR;
	reg CLK, RST_F;
	reg[31:0] IR;

	always       //drive clock, 10ns clock cycle -> 5ns on, 5ns off
		begin
			#5 CLK <= !CLK;
		end

	initial begin
		CLK<=0; RST_F<=1;
		#20 RST_F <=0;
		#5  IR <=32'H00000000; RST_F<=1;//1st instruction nop
		#50 IR <=32'H8801000A;  //2nd instruction add immediate 10 into r[1]
		#50 IR <=32'H88020007;  //3rd instruction add immediate 7 into r[2]
		#50 IR <=32'H80213002;  //4th instruction r[3] <- r[2] - r[1]
		#50 IR <=32'HF0000000;  //halt!!!
		$finish;
	end
endmodule
