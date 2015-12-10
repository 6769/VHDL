entity DFF is
  port (D, CLK: in bit;
        Q: out bit;  QN: out bit := '1');
-- initialize QN to '1' since bit signals are initialized to '0' by default
end DFF;

architecture SIMPLE of DFF is
begin
  process (CLK)  				-- process is executed when CLK changes
  begin
    if CLK'event and CLK = '1' then    			-- rising edge of clock
      Q  <= D after 10 ns;
      QN  <= not D after 10 ns;
    end if;
  end process;
end SIMPLE;		
