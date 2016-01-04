entity Controller is
	port(
	Rb,Reset,  Eq,D7,D711,D2312,CLK:in bit;
	State_debug:out integer range 0 to 3;
	Sp,Roll,Win,Lose,Clear:out bit:='0');
end entity Controller;

architecture Behavior of Controller is
signal State,NextState:integer range 0 to 3:=0;
begin
	State_debug<=State;
	process(Rb,Reset,State)
	begin
		if( Rb='1' or Reset='1' ) then 
		--Roll<=Rb;
		
		case State is
			when 0 =>
				if(D711='1')then Win<='1';NextState<=2;
				elsif(D2312='1') then Lose<='1';NextState<=3;
				else NextState<=1;Sp<='1';
				end if;
			when 2=>
				if(Reset='1') then Win<='0';Lose<='0';NextState<=0;Sp<='0';--Clear<='1';
				end if;
			when 3=>
				if(Reset='1') then Lose<='0';Win<='0';NextState<=0;Sp<='0';--Clear<='1';
				end if;
			when 1=>
				if(Eq='1')then Win<='1' ;NextState<=2;
				elsif(D7='1')then Lose<='1';NextState<=3;
				end if;
			end case;
		end if;
	end process;
	Roll<=Rb;
	Clear<='1' when Reset='1' and (State=2 or State=3) else '0';
	process(CLK)
	begin
		if CLK'event and CLK = '1' then
			State <= NextState;

		end if;
	end process;
end architecture Behavior;
	