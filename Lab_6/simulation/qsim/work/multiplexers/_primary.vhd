library verilog;
use verilog.vl_types.all;
entity multiplexers is
    port(
        DataIn          : in     vl_logic_vector(15 downto 0);
        reg_G           : in     vl_logic_vector(15 downto 0);
        reg0            : in     vl_logic_vector(15 downto 0);
        reg1            : in     vl_logic_vector(15 downto 0);
        control_reg     : in     vl_logic_vector(0 to 7);
        control_GDi     : in     vl_logic_vector(1 downto 0);
        out_to_bus      : out    vl_logic_vector(15 downto 0)
    );
end multiplexers;
