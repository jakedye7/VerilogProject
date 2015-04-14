library verilog;
use verilog.vl_types.all;
entity rf is
    port(
        read_rega       : in     vl_logic_vector(3 downto 0);
        read_regb       : in     vl_logic_vector(3 downto 0);
        write_reg       : in     vl_logic_vector(3 downto 0);
        write_data      : in     vl_logic_vector(31 downto 0);
        rf_we           : in     vl_logic;
        rsa             : out    vl_logic_vector(31 downto 0);
        rsb             : out    vl_logic_vector(31 downto 0)
    );
end rf;
