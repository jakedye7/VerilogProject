library verilog;
use verilog.vl_types.all;
entity mux16 is
    port(
        in_a            : in     vl_logic_vector(15 downto 0);
        in_b            : in     vl_logic_vector(15 downto 0);
        sel             : in     vl_logic;
        \out\           : out    vl_logic_vector(15 downto 0)
    );
end mux16;
