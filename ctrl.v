// 55:035 Porject - Group 22
// Jacob Dye, Matt Fina
// finite state machine

`timescale 1ns/100ps

module ctrl (CLK, RST_F, OPCODE, MM, STAT, RF_WE, ALU_OP, WB_SEL, RD_SEL);
  
  /* TODO: Declare the ports listed above as inputs or outputs */
  // DONE
  input  CLK, RST_F;
  input  [3:0] OPCODE, MM, STAT; //OPCODE = Instr[31:28], MM = Instr[27:24]
  output reg RF_WE, WB_SEL, RD_SEL;
  output reg [1:0] ALU_OP;

  // states
  parameter start0 = 0, start1 = 1, fetch = 2, decode = 3, execute = 4, mem = 5, writeback = 6;
   
  // opcodes
  parameter noop = 0, lod = 1, str = 2, alu_op = 8, bra = 4, brr = 5, bne = 6, hlt=15;
	
  // addressing modes
  parameter am_imm = 8;

  // state registers
  reg [2:0]  present_state, next_state;

  /* TODO: Write a clock process that progresses the fsm to the next state on the
       positive edge of the clock, OR resets the state to 'start0' on the negative edge
       of RST_F. Notice that the computer is reset when RST_F is low, not high. */
  // DONE
  always @ (posedge CLK or negedge RST_F)
  begin
    if (!RST_F) begin
      present_state <= start0;
    end
    else begin
      present_state <= next_state;
    end
  end

  /* TODO: Write a process that determines the next state of the fsm. */
  // DONE
  always @ (present_state)
  begin    
    case (present_state)
      start0:    next_state <= start1;
      start1:    next_state <= decode;
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
    if (OPCODE == hlt)
    begin 
      #1 $display ("Halt."); //Delay 1 ns so $monitor will print the halt instruction
      $stop;
    end
  end
    
  /* TODO: Generate outputs based on the FSM states and inputs. For Parts 2 and 3, you will
       add the new control signals here. */
  // NOP, ADD, ADD imm, SUB, NOT, OR, AND, XOR, ROTR, ROTL, SHFR, SHFL, and HLT -- instructions for part 1
  // output signals - RF_WE, ALU_OP, WB_SEL, RD_SEL; 
  //alu_op = 2'b10 -> non arithmetic operation; alu_op = 2'b01 -> use immediate value
 always @ (posedge CLK)
  begin
    if (OPCODE == noop)
    begin 
      RF_WE <= 1'b0;
      ALU_OP <= 2'b00;
      RD_SEL <= 1'b0;
      WB_SEL <= 1'b0;
    end
  // fetch  -----------------------------------
    if(present_state == fetch)
	begin
		if(OPCODE==alu_op)
		    begin
			RF_WE<=0;
			RD_SEL<=0;
			WB_SEL <=0;
			ALU_OP <=0;
		    end
	end
  // decode ----------------------------------
    else if(present_state==decode) 
	begin 
		if(OPCODE==alu_op)
		    begin
		    end
	end
  // execute -------------------------------
    else if(present_state==execute) 
	begin 
		if(OPCODE==alu_op)
		    begin
			if(MM == 4'b1000)
		    		begin	
					ALU_OP <= 2'b01;
		    		end
			else if(MM == 4'b0000)
				begin
					ALU_OP<= 2'b00;
				end
		    end
	end
  // mem --------------------------------------
    else if(present_state==mem) 
	begin 
		if(OPCODE==alu_op)
		    begin
		    end
	end
  // write back  ----------------------------------
    else if(present_state==writeback) 
	begin 
		if(OPCODE==alu_op)
		    begin
			RF_WE <=1;
			if(MM == 4'b1000)
			   begin
				RD_SEL<=1;
			   end
			else if(MM == 4'b0000)
			   begin
				RD_SEL<=0;
			   end
		    end
	end
  end
endmodule
