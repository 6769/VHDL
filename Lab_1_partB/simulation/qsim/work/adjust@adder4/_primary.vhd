library verilog;
use verilog.vl_types.all;
entity adjustAdder4 is
    port(
        origin          : in     vl_logic_vector(3 downto 0);
        adjusted        : out    vl_logic_vector(3 downto 0);
        carryIn         : in     vl_logic;
        carryAdjusted   : out    vl_logic
    );
end adjustAdder4;
