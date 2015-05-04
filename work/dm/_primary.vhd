library verilog;
use verilog.vl_types.all;
entity dm is
    port(
        read_addr       : in     vl_logic_vector(15 downto 0);
        write_addr      : in     vl_logic_vector(15 downto 0);
        write_data      : in     vl_logic_vector(31 downto 0);
        dm_we           : in     vl_logic;
        read_data       : out    vl_logic_vector(31 downto 0)
    );
end dm;
