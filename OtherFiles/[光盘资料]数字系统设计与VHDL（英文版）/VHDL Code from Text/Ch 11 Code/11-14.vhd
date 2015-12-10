-- memory model with timing (OE_b = 0)
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity static_RAM is
  generic(constant tAA:  time := 15 ns;  -- 6116 static CMOS RAM
          constant tACS: time := 15 ns;
          constant tCLZ: time :=  5 ns;
          constant tCHZ: time :=  2 ns;
          constant tOH:  time :=  5 ns;
          constant tWC:  time := 15 ns;
          constant tAW:  time := 14 ns;
          constant tWP:  time := 12 ns;
          constant tWHZ: time :=  7 ns;
          constant tDW:  time := 12 ns;
          constant tDH:  time :=  0 ns;
          constant tOW:  time :=  0 ns);
  port(CS_b, WE_b, OE_b: in std_logic;
       Address: in unsigned(7 downto 0);
       IO: inout unsigned(7 downto 0) := (others => 'Z'));
end Static_RAM;

architecture SRAM of Static_RAM is
  type RAMtype is array(0 to 255) of unsigned(7 downto 0);
  signal RAM1: RAMtype := (others => (others => '0'));
begin
  RAM: process (CS_b, WE_b, Address)
  begin
    if CS_b = '0' and WE_b = '1' and Address'event then
    -- read when address changes
      IO <= transport "XXXXXXXX" after tOH,
            Ram1(to_integer(Address)) after tAA; end if;
    if falling_edge(CS_b) and WE_b = '1' then
    -- read when CS_b goes low
      IO <= transport "XXXXXXXX" after tCLZ,
            Ram1(to_integer(Address)) after tACS; end if;
    if rising_edge(CS_b) then  -- deselect the chip
      IO <= transport "ZZZZZZZZ" after tCHZ;
      if We_b = '0' then -- CS-controlled write
        Ram1(to_integer(Address'delayed)) <= IO; end if;
    end if;
    if falling_edge(WE_b) and CS_b = '0' then  -- WE-controlled write
      IO <= transport "ZZZZZZZZ" after tWHZ; end if;
    if rising_edge(WE_b) and CS_b = '0' then
      Ram1(to_integer(Address'delayed)) <= IO'delayed;
      IO <= transport IO'delayed after tOW;  -- read back after write
         -- IO'delayed is the value of IO just before the rising edge
    end if;
  end process RAM;

  check: process
  begin
    if NOW /= 0 ns then
      if address'event then
        assert (address'delayed'stable(tWC))    -- tRC = tWC assumed
          report "Address cycle time too short"
          severity WARNING;
      end if;
    -- The following code only checks for a WE_b controlled write: 
      if rising_edge(WE_b) and CS_b'delayed = '0' then
        assert (address'delayed'stable(tAW))
          report "Address not valid long enough to end of write"
          severity WARNING;
        assert (WE_b'delayed'stable(tWP))
          report "Write pulse too short"
          severity WARNING;
        assert (IO'delayed'stable(tDW))
          report "IO setup time too short"
          severity WARNING;
        wait for tDH;
        assert (IO'last_event >= tDH)
          report "IO hold time too short"
          severity WARNING;
      end if;
    end if;
    wait on CS_b, WE_b, Address;
  end process check;
end SRAM;