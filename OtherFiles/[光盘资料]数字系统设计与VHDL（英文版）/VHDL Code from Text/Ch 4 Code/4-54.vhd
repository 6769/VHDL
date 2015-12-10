library IEEE;
use IEEE.numeric_bit.all;

entity sdiv is
  port(CLK, St: in bit;
       Dbus: in unsigned(15 downto 0);
       Quotient: out unsigned(15 downto 0);
       V, Rdy: out bit);
end sdiv;

architecture Signdiv of Sdiv is
signal State: integer range 0 to 6;
signal Count: unsigned(3 downto 0); -- integer range 0 to 15
signal Sign, C, Cm2: bit;
signal Divisor, Sum, Compout: unsigned(15 downto 0);
signal Dividend: unsigned(31 downto 0);
alias Acc: unsigned(15 downto 0) is Dividend(31 downto 16);
begin                                           -- concurrent statements
  Cm2 <= not divisor(15);
  compout <= divisor when Cm2 = '0'-- 1's complementer
             else not divisor;
  Sum <= Acc + compout + unsigned'(0 => Cm2);   -- adder output
  C <= not Sum(15); 	
  Quotient <= Dividend(15 downto 0);
  Rdy <= '1' when State=0 else '0';
  process(CLK)
  begin
    if CLK'event and CLK = '1' then   -- wait for rising edge of clock
      case State is
        when 0=>
          if St = '1' then
            Acc <= Dbus;                             -- load upper dividend
            Sign <= Dbus(15);
            State <= 1;
            V <= '0';                                -- initialize overflow
            Count <= "0000";                         -- initialize counter
          end if;
        when 1=>
          Dividend(15 downto 0) <= Dbus;             -- load lower dividend
          State <= 2;
        when 2=>
          Divisor <= Dbus;
          if Sign ='1' then   -- two's complement Dividend if necessary
            dividend <= not dividend + 1;
          end if;
          State <= 3;
        when 3=>
          Dividend <= Dividend(30 downto 0) & '0';   -- left shift
          Count <= Count+1;
          State <= 4;
        when 4 =>
          if C ='1' then
            v <= '1';
            State <= 0;
          else                                       -- C'
            Dividend <= Dividend(30 downto 0) & '0'; -- left shift
            Count <= Count+1;
            State <= 5;
          end if;
        when 5 =>
          if C = '1' then                            -- C
            ACC <= Sum;                              -- subtract
            dividend(0) <= '1';
          else
            Dividend <= Dividend(30 downto 0) & '0'; -- left shift
            if Count = 15 then State <= 6; end if;   -- KC'
            Count <= Count + 1;
          end if;
        when 6 =>
          state <= 0;   -- (5)
          if C = '1' then                            -- C
            Acc <= Sum;                              -- subtract
            dividend(0) <= '1';
            state <= 6;   -- (6)
          elsif (Sign xor Divisor(15)) = '1' then    -- C'Qneg
            Dividend <= not Dividend + 1;
          end if;                                    -- 2's complement Dividend
          --state <= 0;   -- (7)
          --end if;   -- (2)
      end case;
    end if;
  end process;
end signdiv;