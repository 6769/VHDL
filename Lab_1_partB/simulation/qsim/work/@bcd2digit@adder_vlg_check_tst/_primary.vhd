library verilog;
use verilog.vl_types.all;
entity Bcd2digitAdder_vlg_check_tst is
    port(
        finalCarry      : in     vl_logic;
        result          : in     vl_logic_vector(7 downto 0);
        sampler_rx      : in     vl_logic
    );
end Bcd2digitAdder_vlg_check_tst;
