library verilog;
use verilog.vl_types.all;
entity ctrl is
    generic(
        start0          : integer := 0;
        start1          : integer := 1;
        fetch           : integer := 2;
        decode          : integer := 3;
        execute         : integer := 4;
        mem             : integer := 5;
        writeback       : integer := 6;
        noop            : integer := 0;
        lod             : integer := 1;
        str             : integer := 2;
        alu_op          : integer := 8;
        bra             : integer := 4;
        brr             : integer := 5;
        bne             : integer := 6;
        hlt             : integer := 15;
        am_imm          : integer := 8
    );
    port(
        CLK             : in     vl_logic;
        RST_F           : in     vl_logic;
        OPCODE          : in     vl_logic_vector(3 downto 0);
        MM              : in     vl_logic_vector(3 downto 0);
        STAT            : in     vl_logic_vector(3 downto 0);
        RF_WE           : out    vl_logic;
        \ALU_OP\        : out    vl_logic_vector(1 downto 0);
        WB_SEL          : out    vl_logic;
        RD_SEL          : out    vl_logic;
        PC_SEL          : out    vl_logic;
        PC_WRITE        : out    vl_logic;
        PC_RST          : out    vl_logic;
        BR_SEL          : out    vl_logic;
        MM_SEL          : out    vl_logic;
        DM_WE           : out    vl_logic
    );
end ctrl;
