-- Boundary Scan Tester

entity system is
end system;

architecture IC_test of system is
  component BS_arch is
    generic (NCELLS:natural range 2 to 120 := 4);
    port (TCK, TMS, TDI: in bit;
           TDO: out bit;
           BSRin: in bit_vector(1 to NCELLS);
           BSRout: inout bit_vector(1 to NCELLS);
           CellType: in bit_vector(1 to NCELLS));
                -- '0' for input cell, '1' for output cell
  end component;

  signal TCK,TMS,TDI,TDO,TDO1: bit;
  signal Q0, Q1, CLK1: bit;
  signal BSR1in, BSR1out, BSR2in, BSR2out: bit_vector(1 to 4);
  signal count: integer := 0;

  constant TMSpattern: bit_vector(0 to 62) :=
    "011000000011100000000011110000000111000000000111000000000111111";
  constant TDIpattern: bit_vector(0 to 62) :=
    "000001001000000010001000000000000000001000100000000000000000000";
begin
  BS1: BS_arch port map(TCK, TMS, TDI, TDO1, BSR1in, BSR1out, "0011");
  BS2: BS_arch port map(TCK, TMS, TDO1, TDO, BSR2in, BSR2out, "0011");
	-- each BSR has two input cells and two output cells

  BSR1in(1) <= BSR2out(4);                -- IC1 external connections
  BSR1in(2) <= BSR2out(3);
  BSR1in(3) <= Q1;                        -- IC1 internal logic
  BSR1in(4) <= Q0;
  CLK1 <= not CLK1 after 7 ns;	-- internal clock
  process(CLK1)
  begin
    if (CLK1='1') then	-- D flip-flops
      Q0 <= BSR1out(1);
      Q1 <= BSR1out(2);
    end if;
  end process;

  BSR2in(1) <= BSR1out(4);                -- IC2 external connections
  BSR2in(2) <= BSR1out(3);
  BSR2in(3) <= BSR2out(1) xor BSR2out(2); -- IC2 internal logic
  BSR2in(4) <= not BSR2out(1);

  TCK <= not TCK after 5 ns;			-- test clock
  process
  begin
    TMS <= '1';
    wait for 70 ns;                       -- run internal logic
    wait until TCK='1';
    for i in TMSpattern'range loop        -- run scan test
      TMS <= TMSpattern(i);
      TDI <= TDIpattern(i);
      wait for 0 ns;
      count <= i+1;                       -- count triggers listing output
      wait until TCK='1';
    end loop;
    wait for 70 ns;                       -- run internal logic
    wait;                                 -- stop
  end process;
end IC_test;