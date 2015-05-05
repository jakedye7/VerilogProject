library verilog;
use verilog.vl_types.all;
entity swap_data is
    port(
        a_input         : in     vl_logic_vector(31 downto 0);
        b_input         : in     vl_logic_vector(31 downto 0);
        out_sel         : in     vl_logic;
        data_out        : out    vl_logic_vector(31 downto 0)
    );
end swap_data;
