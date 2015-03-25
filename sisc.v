// 55:035 sisc processor project
// sisc module

`timescale 1ns/100ps

module sisc (CLK, RST_F, IR);
  input CLK, RST_F; 
  input [31:0] IR;
    
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
	wire stat_out;

  // Instantiate and connect all of the components
  mux mux4   (.sel	       (rd_sel),
			        .in_a        (IR[19:16]),
			        .in_b        (IR[15:12]),
			        .out         (mux4_result));

	rf my_rf   (.read_rega   (IR[23:20]),
		          .read_regb   (IR[19:16]),
		          .write_reg   (mux4_result[3:0]),
		          .write_data  (wb_data[31:0]),
		          .rf_we       (rf_we),
		          .rsa         (rsa),
		          .rsb         (rsb));

	alu	my_alu (.alu_op      (alu_op[1:0]),
			        .rsa         (rsa[31:0]),
			        .rsb         (rsb[31:0]),
			        .imm	       (IR[15:0]),
			        .cc 	       (cc),
			        .alu_result  (alu_result));
	
	mux	mux32  (.sel	       (wb_sel),
			        //.in_a      (alu_result[31:0]),
			        //.in_b      (in_b),
			        .in_a				 (1'b0),
			        .in_b				 (alu_result[31:0])
			        .out         (wb_data));

  stat my_s  (.en          (stat_en)
  						.in          (cc[3:0])
  						.out         (stat_out));

	fsm my_fsm (.CLK 	       (CLK),
			        .RST_F       (RST_F),
			        .OPCODE      (IR[31:28]),
			        .MM          (IR[27:24]),
			        .STAT        (stat_out),
			        .RF_WE       (rf_we),
			        .ALU_OP		   (alu_op),
			        .WB_SEL      (wb_sel)
			        .RD_SEL			 (rd_sel));
                 
  initial
  begin
    $monitor ($time,,," IR>: %h, R1=%h, R2=%h, R3=%h", IR, my_rf.ram_array[1], my_rf.ram_array[2], my_rf.ram_array[3]); 
  end 
endmodule