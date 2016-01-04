library verilog;
use verilog.vl_types.all;
entity control is
    port(
        reset           : in     vl_logic;
        rb              : in     vl_logic;
        eq              : in     vl_logic;
        d7              : in     vl_logic;
        d711            : in     vl_logic;
        d2312           : in     vl_logic;
        roll            : out    vl_logic;
        win             : out    vl_logic;
        lose            : out    vl_logic;
        sp              : out    vl_logic
    );
end control;
