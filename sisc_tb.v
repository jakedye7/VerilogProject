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

	initial begin
		RST_F <=1;
		#5 RST_F <=0; CLK<=1;
		#5 CLK<=0;
		#5 RST_F <=0; CLK <=1;
		#5 CLK <=0;
		#5 CLK <=1;  RST_F<=1;
		#5 CLK <=0;
		#5 IR <= 32'H8801000A; CLK <=1;//1st instruction add immediate 10 into r[1]
		#5 CLK <=0;
		#5 CLK <=1;
		#5 CLK <=0;
		#5 CLK <=1;	
		#5 CLK <=0;
		#5 CLK <=1;	
		#5 CLK <=0;
		#5 CLK <=1;	
		#5 CLK <=0;
		#5 CLK <=1; IR <=32'H00000000;  //2nd instruction nop!
		#5 CLK <=0;		
		#5 CLK <=1;	
		#5 CLK <=0;
		#5 CLK <=1;	
		#5 CLK <=0;
		#5 CLK <=1;	
		#5 CLK <=0;
		#5 CLK <=1;	
		#5 CLK <=0;
		#5 CLK <=1; IR <=32'H88020007;  //3rd instruction add immediate 7 into r[2]
		#5 CLK <=0;		
		#5 CLK <=1;	
		#5 CLK <=0;
		#5 CLK <=1;	
		#5 CLK <=0;
		#5 CLK <=1;	
		#5 CLK <=0;
		#5 CLK <=1;	
		#5 CLK <=0;
		#5 CLK <=1; IR <=32'H80213002;  //4th instruction r[3] <- r[2] - r[1]
		#5 CLK <=0;		
		#5 CLK <=1;	
		#5 CLK <=0;
		#5 CLK <=1;	
		#5 CLK <=0;
		#5 CLK <=1;	
		#5 CLK <=0;
		#5 CLK <=1;	
		#5 CLK <=0;
		/*
		#5 CLK <=1; IR <=;  //5th instruction
		#5 CLK <=0;		
		#5 CLK <=1;	
		#5 CLK <=0;
		#5 CLK <=1;	
		#5 CLK <=0;
		#5 CLK <=1;	
		#5 CLK <=0;
		#5 CLK <=1;	
		#5 CLK <=0;
		#5 CLK <=1; IR <=;  //6th instruction
		#5 CLK <=0;		
		#5 CLK <=1;	
		#5 CLK <=0;
		#5 CLK <=1;	
		#5 CLK <=0;
		#5 CLK <=1;	
		#5 CLK <=0;
		#5 CLK <=1;	
		#5 CLK <=0;
		#5 CLK <=1; IR <=;  //7th instruction
		#5 CLK <=0;		
		#5 CLK <=1;	
		#5 CLK <=0;
		#5 CLK <=1;	
		#5 CLK <=0;
		#5 CLK <=1;	
		#5 CLK <=0;
		#5 CLK <=1;	
		#5 CLK <=0;
		#5 CLK <=1; IR <=;  //8th instruction
		#5 CLK <=0;		
		#5 CLK <=1;	
		#5 CLK <=0;
		#5 CLK <=1;	
		#5 CLK <=0;
		#5 CLK <=1;	
		#5 CLK <=0;
		#5 CLK <=1;	
		#5 CLK <=0;
		*/
		#5 CLK <=1; IR <=32'HF0000000;  //halt!!!!
		#5 CLK <=0;		
		#5 CLK <=1;	
		#5 CLK <=0;
		#5 CLK <=1;	
		#5 CLK <=0;
		#5 CLK <=1;	
		#5 CLK <=0;
		#5 CLK <=1;	
		#5 CLK <=0;
		$finish;
	end
endmodule
