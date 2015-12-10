library IEEE;
use IEEE.numeric_bit.all;                 -- to use TO_UNSIGNED(int, size)
use std.textio.all;

entity testfill is
end testfill;

architecture fillmem of testfill is
type RAMtype is array (0 to 8191) of unsigned(7 downto 0);
signal mem: RAMtype := (others => (others => '0'));

procedure fill_memory(signal mem: inout RAMType) is
type HexTable is array (character range <>) of integer;
-- valid hex chars: 0, 1, ... A, B, C, D, E, F (upper-case only)
constant lookup: HexTable('0' to 'F'):=
  (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, -1, -1, -1,
   -1, -1, -1, -1, 10, 11, 12, 13, 14, 15);
file infile: text open read_mode is "mem1.txt"; -- open file for reading
-- file infile: text is in "mem1.txt";          -- VHDL '87 version
variable buff: line;
variable addr_s: string(4 downto 1);
variable data_s: string(3 downto 1);            -- data_s(1) has a space
variable addr1, byte_cnt: integer;
variable data: integer range 255 downto 0;
begin
  while (not endfile(infile)) loop
    readline(infile, buff);
    read(buff, addr_s);                         -- read addr hexnum
    read(buff, byte_cnt);                       -- read number of bytes to read
    addr1 := lookup(addr_s(4)) * 4096 + lookup(addr_s(3)) * 256
             + lookup(addr_s(2)) * 16 + lookup(addr_s(1));
    readline(infile, buff);
    for i in 1 to byte_cnt loop
      read(buff, data_s);                  -- read 2 digit hex data and a space
      data := lookup(data_s(3)) * 16 + lookup(data_s(2));
      mem(addr1) <= TO_UNSIGNED(data, 8);
      addr1:= addr1 + 1;
    end loop;
  end loop;
end fill_memory;

begin
  testbench: process
  begin
    fill_memory(mem);
    -- insert code which uses memory data 
    
    wait for 40 ns;
  end process;
end fillmem;
