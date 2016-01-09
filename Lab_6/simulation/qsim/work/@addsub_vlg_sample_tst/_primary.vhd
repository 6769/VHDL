library verilog;
use verilog.vl_types.all;
entity Addsub_vlg_sample_tst is
    port(
        a               : in     vl_logic_vector(15 downto 0);
        b               : in     vl_logic_vector(15 downto 0);
        select_add_sub  : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end Addsub_vlg_sample_tst;
