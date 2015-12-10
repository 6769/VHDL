-- This VHDL model explicitly defines control signals.

library IEEE;
use IEEE.numeric_bit.all;

entity mult2C2 is
  port(CLK, St: in bit;
       Mplier, Mcand: in unsigned(3 downto 0);
       Product: out unsigned (6 downto 0);
       Done: out bit);
end mult2C2;

-- This architecture of a 4-bit multiplier for 2's complement numbers
-- uses control signals.

architecture behave2 of mult2C2 is
signal State, Nextstate: integer range 0 to 5;
signal A, B, compout, addout: unsigned(3 downto 0);
signal AdSh, Sh, Load, Cm: bit;
alias M: bit is B(0);
begin
  process(State, St, M)
  begin
    Load <= '0'; AdSh <= '0'; Sh <= '0'; Cm <= '0'; Done <= '0'; 
    case State is
      when 0=>            -- initial state
        if St='1' then Load <= '1'; Nextstate <= 1; end if;
      when 1 | 2 | 3  =>  -- "add/shift" State
        if M = '1' then AdSh <= '1';
        else Sh <= '1';
        end if;
        Nextstate <= State + 1;
      when 4  =>          -- add complement if sign 
        if M = '1' then   -- bit of multiplier is 1
          Cm <= '1'; AdSh <= '1';
        else Sh <= '1';
        end if;
        Nextstate <= 5;
      when 5 =>           -- output product
        Done <= '1';
        Nextstate <= 0;
    end case;
  end process;

  compout <= not Mcand when Cm = '1' else Mcand; -- complementer
  addout <= A + compout + unsigned'(0=>Cm);      -- 4-bit adder with carry in

  process(CLK)
  begin
    if CLK'event and CLK = '1' then   -- executes on rising edge   -- (1)
      if Load = '1' then          -- load the multiplier
        A <= "0000";
        B <= Mplier;
      end if;
      if AdSh = '1' then          -- add multiplicand to A and shift
        A <= compout(3) & addout(3 downto 1);
        B <= addout(0) & B(3 downto 1);
      end if;
      if Sh = '1' then
        A <= A(3) & A(3 downto 1);
        B <= A(0) & B(3 downto 1);
      end if;
      State <= Nextstate;
    end if;
  end process;
  Product <= A(2 downto 0) & B;
end behave2;