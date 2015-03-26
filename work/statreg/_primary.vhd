library verilog;
use verilog.vl_types.all;
entity statreg is
    port(
        \in\            : in     vl_logic_vector(3 downto 0);
        enable          : in     vl_logic;
        \out\           : out    vl_logic_vector(3 downto 0)
    );
end statreg;
