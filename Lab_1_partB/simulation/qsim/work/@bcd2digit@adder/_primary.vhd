library verilog;
use verilog.vl_types.all;
entity Bcd2digitAdder is
    port(
        adder1          : in     vl_logic_vector(7 downto 0);
        adder2          : in     vl_logic_vector(7 downto 0);
        result          : out    vl_logic_vector(7 downto 0);
        finalCarry      : out    vl_logic
    );
end Bcd2digitAdder;
