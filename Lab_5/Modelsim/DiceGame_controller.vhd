library ieee ;
use ieee.numeric_bit.all;

entity DiceGame_controller is 
  port(Rb, Reset, CLK: in bit;
       Sum: in integer range 2 to 12;
       Roll, Win, Lose: out bit);
end DiceGame_controller;

architecture DiceGameControl of DiceGame_controller is

signal State, Nextstate: integer range 0 to 5:=0; 
signal Point: integer range 2 to 12;
signal Sp: bit;
begin
  process(Rb, State)
  begin
    --Sp <= '0'; Roll <= '0'; Win <= '0'; Lose <= '0';
    case State is
      when 0 => 
		
		if Rb = '1' then Nextstate <= 1; 
        else  Nextstate<=0;
        end if;
      when 1 => 
		
        if Sum = 7 or Sum = 11 then Nextstate <= 2;
        elsif Sum = 2 or Sum = 3 or Sum =12 then Nextstate <= 3;
        else  Nextstate <= 4;--Sp <= '1' ;
        end if;
      when 2 => 
		
		--Win <= '1';
        --if Reset = '1' then Nextstate <= 0; end if;
      when 3 => 
		
		--Lose <= '1';
        --if Reset = '1' then Nextstate <= 0; end if;
      when 4 => 
		if Rb = '1' then Nextstate <= 5; end if;
      when 5 =>
	  
        if Sum = Point then Nextstate <= 2;
        elsif Sum = 7 then Nextstate <= 3;
        else Nextstate <= 4;
        end if;
    end case;
  end process;

  
  process(CLK)
  begin
    if CLK'event and CLK = '1' then
      
      if Sp = '1' then Point <= Sum; end if;
	  if Reset='1' then State<=0;
	  else State <= Nextstate;
	  end if;
    end if;
  end process;
  Win<='1' when State=2 and Rb='0'
    else '0';
  Lose<='1' when State=3 and Rb='0'
    else '0';

  Roll<=Rb;
  Sp <= '1' when State=1 else '0';

end DiceGameControl;