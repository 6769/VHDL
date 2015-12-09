library verilog;
use verilog.vl_types.all;
entity clock_second is
    port(
        clk50Mhz        : in     vl_logic;
        second          : out    vl_logic
    );
end clock_second;
