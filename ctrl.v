// 55:035 Porject - Group 22
// Jacob Dye, Matt Fina
// finite state machine

`timescale 1ns/100ps

module ctrl (CLK, RST_F, OPCODE, MM, STAT, RF_WE, ALU_OP, WB_SEL, RD_SEL, PC_SEL, PC_WRITE, PC_RST, BR_SEL);
  
  // inputs and outputs
  input  CLK, RST_F;
  input  [3:0] OPCODE, MM, STAT; //OPCODE = Instr[31:28], MM = Instr[27:24]
  output reg RF_WE, WB_SEL, RD_SEL, PC_SEL, PC_WRITE, PC_RST, BR_SEL;
  output reg [1:0] ALU_OP;
	//control signals added for part 2 - pc_sel, pc_write, pc_rst, br_sel

  // states
  parameter start0 = 0, start1 = 1, fetch = 2, decode = 3, execute = 4, mem = 5, writeback = 6;
   
  // opcodes
  parameter noop = 0, lod = 1, str = 2, alu_op = 8, bra = 4, brr = 5, bne = 6, hlt = 15;
	
  // addressing modes
  parameter am_imm = 8;

  // state registers
  reg [2:0] present_state, next_state;

  initial
  begin
		PC_RST <= 1;
		PC_WRITE <= 1;
  end

  // <------------------------------------------------------------------ JAKE
  // reset for Program Counter
  //always @ (RST_F)
  //begin
  //  if(!RST_F) begin
  //    PC_RST <= 1;
  //  end
  //  else begin
  //   	PC_RST <= 0;  
  //  end 
  //end
  // ------------------------------------------------------------------------

  // clock process
  always @ (posedge CLK or negedge RST_F)
  begin
    if(!RST_F) begin
	  	present_state <= start0;
    end
    else begin
      present_state <= next_state;
    end
  end
	
  // process that determines the next state of the fsm
  always @ (present_state)
  begin    
    case(present_state)
      start0:    next_state <= start1;
      start1:    next_state <= fetch;
      fetch:     next_state <= decode;     
      decode:    next_state <= execute;
      execute:   next_state <= mem;
      mem:       next_state <= writeback;
      writeback: next_state <= fetch;     
    endcase
  end

  // Halt on HLT instruction
  always @ (OPCODE)
  begin
    if(OPCODE == hlt)
    begin 
      #1 $display ("Halt."); //Delay 1 ns so $monitor will print the halt instruction
      $stop;
    end
  end

  // outputs based on the FSM states and inputs
  // NOP, ADD, ADD imm, SUB, NOT, OR, AND, XOR, ROTR, ROTL, SHFR, SHFL, and HLT -- instructions for part 1
  // output signals - RF_WE, ALU_OP, WB_SEL, RD_SEL
  // alu_op = 2'b10 -> non arithmetic operation; alu_op = 2'b01 -> use immediate value
 	always @ (posedge CLK)
  begin
    if(OPCODE == noop)
    begin 
      RF_WE <= 1'b0;
      ALU_OP <= 2'b00;
      RD_SEL <= 1'b0;
      WB_SEL <= 1'b0;
      PC_SEL <= 0;
      PC_RST <= 0;
      BR_SEL <= 0;
    end

  	// fetch  -----------------------------------
    if(present_state == fetch)
		begin
			PC_WRITE <= 1;
			//PC_SEL <= 0;
			PC_RST <= 0;

			if(OPCODE == alu_op)
		  begin
				PC_SEL <= 0;
				BR_SEL <= 0;
				RF_WE <= 0;
				WB_SEL <= 0;
				ALU_OP <= 0;
		  end

		  // <----------------------------------------------------------------------------- JAKE
		  //if((OPCODE == bne) || (OPCODE == bra))
		  //begin
		  //	RF_WE <= 0;
			//	WB_SEL <= 0;
			//	ALU_OP <= 2'b10;
			//	BR_SEL <= 1;
		  //end
		  //else if(OPCODE == brr)
		  //begin
			//	RF_WE <= 0;
			//	WB_SEL <= 0;
			//	ALU_OP <= 2'b10;
			//	BR_SEL <= 0;
		  //end
		  // -----------------------------------------------------------------------------------
		  // ^^^^^ 
		  // THIS STUFF INSTEAD OF NEXT 3 IF's ???

			if(OPCODE == 4'H6) //bne
			begin
				RF_WE <= 0;
				WB_SEL <= 0;
				ALU_OP <= 2'b10;
				BR_SEL <= 1;			
			end

			if(OPCODE == 4'H5) //brr
			begin
				RF_WE <= 0;
				WB_SEL <= 0;
				ALU_OP <= 2'b10;
				BR_SEL <= 0;  // should this be assigned 1?   <--- ???
			end

			if(OPCODE == 4'H4) //bra
			begin
				RF_WE <= 0;
				WB_SEL <= 0;
				ALU_OP <= 2'b10;
				BR_SEL <= 1;
			end
		end

  	// decode ----------------------------------
   	else if(present_state == decode) 
		begin 
			PC_WRITE <= 0;
			//PC_SEL <= 0; // <--------------------------------------------------- JAKE
			
			if(OPCODE == alu_op)
		  begin
				if(MM == 4'b1000)
					RD_SEL <= 1;
				else 
					RD_SEL <= 0;
		  end
			else
			begin
				RD_SEL <= 0;
			end
		end

  	// execute -------------------------------
    else if(present_state == execute) 
		begin 
			if(OPCODE == alu_op)
		  begin
				if(MM == 4'b1000)
          ALU_OP <= 2'b01;
				else 
					ALU_OP <= 2'b00;
		  end
		
			if(OPCODE == 4'H6)
			begin
				//PC_WRITE <= 1; <-------------- Should only be 1 for FETCH right ???

				if(STAT == MM)
					PC_SEL <= 1; //take branch
				else
					PC_SEL <= 0; //dont take branch
			end

			if(OPCODE == 4'H5) //brr
			begin
			
			end

			if(OPCODE == 4'H4) //bra
			begin
			
			end
		end

  	// mem --------------------------------------
    else if(present_state == mem) 
		begin 
			if(OPCODE == alu_op)
				RF_WE <= 1;
		end

  	// write back  ----------------------------------
  	else if(present_state == writeback) 
		begin 
			if(OPCODE == alu_op)
			begin
			
			end
		end

    // -------------------------------------------------------------------------------- JAKE
		//else if(present_state == writeback)
		//begin
		//	if(((OPCODE == 4'H4) || (OPCODE == 4'H5) || (OPCODE == 4'H6)) && (MM == 4'H0))
		//		PC_SEL <= 1'b1; 
    //end
    // -------------------------------------------------------------------------------------
  end
endmodule
