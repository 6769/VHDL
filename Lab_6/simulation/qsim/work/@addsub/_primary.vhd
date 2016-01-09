library verilog;
use verilog.vl_types.all;
entity Addsub is
    port(
        a               : in     vl_logic_vector(15 downto 0);
        b               : in     vl_logic_vector(15 downto 0);
        select_add_sub  : in     vl_logic;
        result          : out    vl_logic_vector(15 downto 0)
    );
end Addsub;
