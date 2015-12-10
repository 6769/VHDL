library IEEE;
use IEEE.numeric_bit.all;

entity mult2C is
  port(CLK, St: in bit;
       Mplier, Mcand : in unsigned(3 downto 0);
       Product: out unsigned (6 downto 0);
       Done: out bit);
end mult2C;

architecture behave1 of mult2C is
signal State: integer range 0 to 5;
signal A, B: unsigned(3 downto 0);
alias M: bit is B(0);
begin
  process(CLK)
  variable addout: unsigned(3 downto 0); 
  begin
    if CLK'event and CLK = '1' then
      case State is
        when 0 =>                -- initial State
          if St='1' then 
            A <= "0000";         -- begin cycle
            B <= Mplier;         -- load the multiplier
            State <= 1;
          end if;
        when 1 | 2 | 3 =>       -- "add/shift" states
          if M = '1' then
            addout := A + Mcand;  -- add multiplicand to A and shift
            A <= Mcand(3) & addout(3 downto 1);
            B <= addout(0) & B(3 downto 1);
          else
            A <= A(3) & A(3 downto 1);  -- arithmetic right shift
            B <= A(0) & B(3 downto 1);
          end if;
          State <= State + 1;
        when 4 =>
          if M = '1' then
            addout := A + not Mcand + 1;
              -- add 2's complement when sign bit of multiplier is 1
            A <= not Mcand(3) & addout(3 downto 1);
            B <= addout(0) & B(3 downto 1);
          else 
            A <= A(3) & A(3 downto 1);  -- arithmetic right shift
            B <= A(0) & B(3 downto 1);
          end if;
          State <= 5;
        when 5 =>
          State <= 0;
      end case;
    end if;
  end process;
  Done <= '1' when State = 5 else '0';
  Product <= A(2 downto 0) & B;     -- output product
end behave1;