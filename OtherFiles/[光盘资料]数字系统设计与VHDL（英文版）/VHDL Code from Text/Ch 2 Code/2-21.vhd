entity JKFF is
  port(SN, RN, J, K, CLK: in bit; -- inputs
       Q, QN: out bit);
end JKFF;

architecture JKFF1 of JKFF is
signal Qint: bit;                 -- Qint can be used as input or output
begin
  Q <= Qint;                      -- output Q and QN to port
  QN <= not Qint;                 -- combinational output
                                  -- outside process
  process(SN, RN, CLK)
  begin
    if RN = '0' then  Qint <= '0' after 8 ns; -- RN='0' will clear the FF
    elsif SN = '0' then Qint <= '1' after 8 ns; -- SN='0' will set the FF
    elsif CLK'event and CLK = '0' then          -- falling edge of CLK
      Qint <= (J and not Qint) or (not K and Qint) after 10 ns;
    end if;
  end process;
end JKFF1;
