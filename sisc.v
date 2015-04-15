// 55:035 sisc processor project
// sisc module
//Matt Fina & Jacob Dye

`timescale 1ns/100ps

module sisc (CLK, RST_F);
  input CLK, RST_F; 
  //input [31:0] IR; part2 generates own IR
    
  // Datapath and control signals
  wire [3:0] mux4_result;
	wire [31:0] wb_data;
	wire [31:0] rsa;
	wire [31:0] rsb;
	wire rf_we;
	wire imm_sel;
	wire shf_ctl;
	wire [1:0] log_ctl;
	wire sub;
	wire cc_en;
	wire [3:0] cc;
	wire [31:0] alu_result;
	wire wb_sel;
	wire [31:0] in_b;
	wire [1:0] alu_op;
	wire [3:0] stat_out;
	wire rd_sel;

	//part 2 additions
	wire [15:0] pc_out;
	wire [15:0] pc_inc;
	wire [15:0] branch_address;
	wire [31:0] IR;
	//part 2 control signals
	wire pc_write;
	wire pc_sel;
	wire pc_rst;
	wire br_sel;

  // Instantiate and connect all of the components
  mux4 amux4   (.in_a        (IR[15:12]),
			        	.in_b        (IR[19:16]),
								.sel	       (rd_sel),
			        	.out         (mux4_result));

	rf my_rf   (.read_rega   (IR[23:20]),
		          .read_regb   (IR[19:16]),
		          .write_reg   (mux4_result[3:0]),
		          .write_data  (wb_data[31:0]),
		          .rf_we       (rf_we),
		          .rsa         (rsa),
		          .rsb         (rsb));

	alu	my_alu (.rsa         (rsa[31:0]),
			        .rsb         (rsb[31:0]),
			        .imm	       (IR[15:0]),
							.alu_op      (alu_op[1:0]),
			        .alu_result  (alu_result),
							.stat 	     (cc),
							.stat_en 		 (cc_en));
	
	mux32	amux32  (.in_a				 (32'h00000000),
			        	 .in_b				 (alu_result[31:0]),
								 .sel	       	 (wb_sel),
			        	 .out          (wb_data));

  statreg my_s  (.in          (cc[3:0]),
								 .enable      (cc_en),
  							 .out         (stat_out));

	ctrl my_ctrl (.CLK 	       (CLK),
			        	.RST_F       (RST_F),
			        	.OPCODE      (IR[31:28]),
			        	.MM          (IR[27:24]),
			        	.STAT        (stat_out),
			        	.RF_WE       (rf_we),
			        	.ALU_OP		   (alu_op),
			        	.WB_SEL      (wb_sel),
			        	.RD_SEL			 (rd_sel),
							  .PC_SEL 		 (pc_sel),
							  .PC_WRITE 	 (pc_write),
								.PC_RST 		 (pc_rst),
								.BR_SEL 		 (br_sel));
					
	pc progcounter (.br_addr 	 (branch_address[15:0]),
								  .pc_sel 	 (pc_sel), 
								  .pc_write  (pc_write), 
								  .pc_rst 	 (pc_rst),
									.pc_out		 (pc_out[15:0]),
									.pc_inc		 (pc_inc[15:0]));
					
	im instr_mem (.read_addr 	(pc_out[15:0]),
								.read_data 	(IR[31:0]));
				
	br branch(.pc_inc 	(pc_inc[15:0]), 
						.imm 		  (IR[15:0]),
						.br_sel 	(br_sel),
						.br_addr 	(branch_address));
                 
  initial
  begin
    $monitor ($time,,," IR>: %h, PC=%h, R1=%h, R2=%h, R3=%h, RD_SEL=%b, ALU_OP=%b, WB_SEL=%b, RF_WE=%b, BR_SEL=%b, PC_WRITE=%b, PC_SEL=%b Add=%h, STAT=%b,PC_IN=%b", IR, pc_out, my_rf.ram_array[1], my_rf.ram_array[2], my_rf.ram_array[3], rd_sel, alu_op, wb_sel, rf_we, br_sel, pc_write, pc_sel, branch_address,stat_out,progcounter.pc_in ); 
  end 
endmodule
