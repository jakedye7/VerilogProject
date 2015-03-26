library verilog;
use verilog.vl_types.all;
entity sisc is
    port(
        CLK             : in     vl_logic;
        RST_F           : in     vl_logic;
        IR              : in     vl_logic_vector(31 downto 0)
    );
end sisc;
