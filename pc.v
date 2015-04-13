// 55:035 sisc processor project
// program counter

`timescale 1ns/100ps

module pc (br_addr, pc_sel, pc_write, pc_rst, pc_out, pc_inc);

  /*
   *  PROGRAM COUNTER - pc.v
   *
   *  Inputs:
   *   - br_addr (16 bits): The branch address computed by the br module.
   *   - pc_sel: This control bit tells the pc module whether to save the branch
   *        address (pc_sel = 0) or PC+1 (pc_sel = 1) to the program counter.
   *   - pc_en: When this control bit changes to 1, the selected value (either
   *        the branch address or PC+1) is saved to pc_out and held there until
   *        the next time pc_en is set to 1.
   *   - pc_rst: This resets the program counter to 0x0000 when set to 1.
   *
   *  Outputs:
   *   - pc_out (16 bits): This is the current value of the program counter, to
   *        be used in the instruction memory (im.v) module.
   *   - pc_inc (16 bits): Always equal to PC+1, used in calculating relative
   *        branch addresses in br.v, and also used internally to increment PC
   *        during non-branch instructions.
   *
   */

  input  [15:0] br_addr;
  input         pc_sel;
  input         pc_write;
  input         pc_rst;
  output [15:0] pc_out;
  output [15:0] pc_inc;

  reg    [15:0] pc_in;
  reg    [15:0] pc_out;
  wire   [15:0] pc_inc;
 
  // program counter latch
  always @(posedge pc_write)
    pc_out <= pc_in;
  
  always @ (pc_rst)
    if (pc_rst == 1'b1)
      pc_out <= 16'h0000;
  
  always @ (br_addr, pc_inc, pc_sel)
  begin
    if (pc_sel == 1'b0)
      pc_in <= pc_inc;
    else
      pc_in <= br_addr;
  end

  assign pc_inc = pc_out + 1;

endmodule
