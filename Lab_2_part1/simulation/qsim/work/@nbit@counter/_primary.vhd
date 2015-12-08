library verilog;
use verilog.vl_types.all;
entity NbitCounter is
    port(
        clear           : in     vl_logic;
        clk             : in     vl_logic;
        enable          : in     vl_logic;
        Q               : out    vl_logic_vector(15 downto 0)
    );
end NbitCounter;
