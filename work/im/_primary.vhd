library verilog;
use verilog.vl_types.all;
entity im is
    port(
        read_addr       : in     vl_logic_vector(15 downto 0);
        read_data       : out    vl_logic_vector(31 downto 0)
    );
end im;
