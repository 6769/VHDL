library verilog;
use verilog.vl_types.all;
entity Bcd2digitAdder_vlg_sample_tst is
    port(
        adder1          : in     vl_logic_vector(7 downto 0);
        adder2          : in     vl_logic_vector(7 downto 0);
        sampler_tx      : out    vl_logic
    );
end Bcd2digitAdder_vlg_sample_tst;
