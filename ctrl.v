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

  // clock process
  always @ (posedge CLK or negedge RST_F)
  begin
    if(!RST_F) begin
			PC_RST <= 1;	
  		present_state <= start0;
    end
    else begin
			PC_RST <= 0;
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
			PC_SEL <= 0;
			PC_RST <= 0;

		if(OPCODE == alu_op)
		 	 begin
				PC_SEL <= 0;
				//BR_SEL <= 1;
				BR_SEL <= 0;	
				RF_WE <= 0;
				WB_SEL <= 0;
				ALU_OP <= 0;
		  	end
  
		if((OPCODE == bne) || (OPCODE == brr) || (OPCODE == bra))
		 	 begin
		  		RF_WE <= 0;
				WB_SEL <= 0;
				ALU_OP <= 2'b10;
			end
	end

  	// decode ----------------------------------
   	else if(present_state == decode) 
		begin 
			PC_WRITE <= 0;
			//PC_SEL <= 0; 
			
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
					begin
          					ALU_OP <= 2'b01;
					end
				else 
					begin 
						ALU_OP <= 2'b00;
				end		  
			end
		
			if(OPCODE == bne)
			begin
				if((MM&STAT) == 4'b0000)
				begin
					//PC_WRITE <= 1; dont need to write here, setting present_state to fetch will write the correct instr
					$display("branching negative");
					PC_SEL <= 1; //take branch
					BR_SEL <= 1;
					present_state <= fetch;
				end
				else
				begin
					$display("branching negative fail");
					PC_SEL <= 0; //dont take branch
				end
			end

			if(OPCODE == brr)
			begin
				
			
				if( (MM&STAT)!= 4'b0000 )
					begin
						$display("branching relative");
						PC_SEL <=1;
						BR_SEL<=0; //relatvie branch
						present_state <= fetch;
					end
				else 
					begin
						$display("branching relative fail");
						PC_SEL <= 0; //dont take branch
					end
			end

			if(OPCODE == bra)
			begin
				
			
				if( (MM&STAT)!= 4'b0000 )
					begin
						$display("branching absolute");
						PC_SEL <=1;
						BR_SEL<=1;//absoluten branch
						present_state <= fetch;
					end
				else 
					begin	
						$display("branching absolute fail");
						PC_SEL <= 0; //dont take branch
					end
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
			if(OPCODE == alu_op) begin
				
			end
		end

  end
endmodule
