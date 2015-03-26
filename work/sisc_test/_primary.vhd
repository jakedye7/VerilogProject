library verilog;
use verilog.vl_types.all;
entity sisc_test is
    port(
        CLK             : out    vl_logic;
        RST_F           : out    vl_logic;
        IR              : out    vl_logic_vector(31 downto 0)
    );
end sisc_test;
