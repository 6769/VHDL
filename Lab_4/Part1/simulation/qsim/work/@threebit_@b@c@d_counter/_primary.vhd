library verilog;
use verilog.vl_types.all;
entity Threebit_BCD_counter is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        Counter_Result  : out    vl_logic_vector(11 downto 0)
    );
end Threebit_BCD_counter;
