// 55:035 sisc processor project
// arithmetic logic unit

`timescale 1ns/100ps

module alu (rsa, rsb, imm, alu_op, alu_result, stat, stat_en);

  /*
   *  ARITHMETIC LOGIC UNIT - alu.v
   *  
   *  Inputs:
   *   - rsa (32 bits): Contents of first register read from the register file (rf.v),
   *        equivalent to Rs in the instruction set architecture.
   *   - rsb (32 bits): Register B from the register file, equivalent to Rt in the ISA.
   *   - imm (16 bits): Immediate value, to be taken from the last 16 bits of the
   *        instruction. This is always sign-extended for use in the adder. The bottom
   *        four bits of this field also forms the function code, which specifies which
   *        operation the ALU should perform and propagate to the output.
   *   - alu_op (2 bits): This control line allows the control unit to override the
   *        usual function of the ALU to perform specific operations. When bit 1 is set
   *        to 1, the control unit is telling the ALU that the instruction being
   *        executed is not an arithmetic operation, and thus, the status code should
   *        not be saved to the status register. For loads and stores, though, the ALU
   *        may still be needed. When bit 0 is set to 1, the immediate value is used
   *        as the second operand to the adder, rather than RB.
   *
   *  Outputs:
   *   - alu_result (32 bits): This is the output for the entire ALU.
   *   - stat (4 bits): These bits describe the nature of the output of the adder:
   *        Bit 3 (Carry) - Set to 1 when the addition or subtraction produces a carry
   *          or borrow, respectively. Useful when multiplying numbers.
   *        Bit 2 (oVerflow) - Set to 1 when the adder overflows. Note that this is not
   *          equivalent to the carry bit, as two negative numbers can produce a carry
   *          without overflowing.
   *        Bit 1 (Negative) - Set to 1 when the add or subtract operation would result
   *          in a negative number, EVEN in the case of over-/underflow. For example,
   *          adding 0x7FFFFFFF (2^31 - 1) and 0x00000001, the ALU will overflow and
   *          output 0x80000000 (-2^31). The overflow bit will be set high, but the
   *          negative bit will NOT, because the "ideal" output of the addition is
   *          2^31, a positive number.
   *        Bit 0 (Zero) - Set to 1 when the adder output is equal to zero.
   *   - stat_en: This line controls when the status register should save the status
   *        bits put out by the ALU. This is only set to 1 for ADD and SUB instructions.
   *
   */
  
  input   [31:0] rsa;
  input   [31:0] rsb;
  input   [15:0] imm;
  input   [1:0]  alu_op;
  output  [31:0] alu_result;
  output  [3:0]  stat;
  output         stat_en;
 
  wire [3:0]  stat;
  reg  [32:0] add_out;
  reg  [31:0] log_out;
  reg  [31:0] shf_out;
  reg  [31:0] alu_out;
  reg  [31:0] reg_rot;
  reg  [31:0] imm_ext;
  wire [3:0]  funct;
  wire        stat_en;
  reg t;
  integer i;

  // function codes
  parameter add = 1, sub = 2, lnot = 4, lor = 5, land = 6, lxor = 7;
  parameter shf_r = 10, shf_l = 11, rot_r = 8, rot_l = 9;

  // extract the function bits from the imm value
  assign funct = imm[3:0];

  // sign-extend the immediate value
  always @ (imm)
  begin
    if (imm[15] == 1'b0)
      imm_ext[31:16] = 16'h0000;
    else
      imm_ext[31:16] = 16'hFFFF;
    imm_ext[15:0] = imm;
  end

  // adder
  always @ (rsa, rsb, funct, imm_ext, alu_op)
    if (alu_op[0] == 1'b0)
      if (funct == sub)
        add_out <= rsa - rsb;
      else
        add_out <= rsa + rsb;
    else
      add_out <= rsa + imm_ext; //sub immediate not supported
  
  // logic  
  always @ (rsa, rsb, funct)
    case (funct[1:0])
      2'b00:    log_out <= ~rsa;
      2'b01:     log_out <= rsa | rsb;
      2'b10:    log_out <= rsa & rsb;
      2'b11:    log_out <= rsa ^ rsb;
    endcase

  // shifter
  always @ (rsa, rsb, funct)
    case (funct[1:0])
      2'b10: begin                   // shift right
        shf_out <= rsa >> rsb; 
      end 
      2'b11: begin                   // shift left
        shf_out <= rsa << rsb;  
      end
      2'b00: begin                   // rotate right
        reg_rot = rsa;
        for (i = 0; i < rsb[4:0]; i = i + 1) begin
          t = reg_rot[0];
          reg_rot[30:0] = reg_rot[31:1];
          reg_rot[31] = t;
        end
        shf_out = reg_rot;
      end  
      2'b01: begin                   // rotate left
        reg_rot = rsa;
        for (i = 0; i < rsb[4:0]; i = i + 1) begin
          t = reg_rot[31];
          reg_rot[31:1] = reg_rot[30:0];
          reg_rot[0] = t;
        end
        shf_out = reg_rot;
      end      
    endcase    
      
  // mux
  always @ (add_out, log_out, shf_out, funct, alu_op)
  begin
    if (alu_op[0] == 1'b1)
      alu_out <= add_out[31:0];
    else
    begin
      case (funct[3:2])
        2'b00: alu_out <= add_out[31:0];
        2'b01: alu_out <= log_out;
        2'b10: alu_out <= shf_out;
        2'b11: alu_out <= 32'H00000000;
      endcase
    end  
  end    

  // status code generation 
  // 3 = Carry; 2 = oVerflow; 1 = Negative; 0 = Zero
  // Assume signed operands
  assign stat[3] = (add_out[32] == 1'b1) ? 1'b1 : 1'b0;
  assign stat[2] = (!(rsa[31] ^ rsb[31] ^ sub) && (rsb[31] ^ add_out[31]));
  assign stat[1] = ((!(rsa[31] ^ rsb[31] ^ sub) && (rsb[31] ^ add_out[31])) ^ (add_out[31] == 1'b1))  ? 1'b1 : 1'b0;
  assign stat[0] = (add_out[31:0] == 32'H00000000) ? 1'b1 : 1'b0;

  assign alu_result = alu_out;

  // status register enable
  assign stat_en = ((funct == add) || (funct == sub)) && (alu_op[1] == 1'b0) ? 1'b1 : 1'b0;

endmodule
