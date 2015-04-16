library verilog;
use verilog.vl_types.all;
entity alu is
    generic(
        add             : integer := 1;
        sub             : integer := 2;
        lnot            : integer := 4;
        lor             : integer := 5;
        land            : integer := 6;
        lxor            : integer := 7;
        shf_r           : integer := 10;
        shf_l           : integer := 11;
        rot_r           : integer := 8;
        rot_l           : integer := 9
    );
    port(
        rsa             : in     vl_logic_vector(31 downto 0);
        rsb             : in     vl_logic_vector(31 downto 0);
        imm             : in     vl_logic_vector(15 downto 0);
        alu_op          : in     vl_logic_vector(1 downto 0);
        alu_result      : out    vl_logic_vector(31 downto 0);
        stat            : out    vl_logic_vector(3 downto 0);
        stat_en         : out    vl_logic
    );
end alu;
