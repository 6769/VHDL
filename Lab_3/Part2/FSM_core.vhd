--lab3-Part1
--FSM with 0-8 state

entity FSM_core is
    port(X:in bit;
	CLK:in bit;
	reset:in bit;
	stateout:out integer range 0 to 8;
	Z:out bit);
end entity FSM_core;

architecture Behavior of FSM_core is

signal State,nextState:integer range 0 to 8;
begin
	stateout<=state;
    process(X,State)
    begin
        case State is 
            when 0=>
                Z<='0';
                if X='0' then nextState<=5;
                else nextState<=1;
                end if;
            when 1=>
                Z<='0';
                if X='0' then nextState<=5;
                else nextState<=2;
                end if;
            when 2=>
                Z<='0';
                if X='0' then nextState<=5;
                else nextState<=3;
                end if;
            when 3=>
                Z<='0';
                if X='0' then nextState<=5;
                else nextState<=4;
                end if;
            when 4=>
                Z<='1';
                if X='0' then nextState<=5;
                else nextState<=4;
                end if;
            when 5=>
                Z<='0';
                if X='0' then nextState<=6;
                else nextState<=1;
                end if;
            when 6=>
                Z<='0';
                if X='0' then nextState<=7;
                else nextState<=1;
                end if;
            when 7=>
                Z<='0';
                if X='0' then nextState<=8;
                else nextState<=1;
                end if;
            when 8=>
                Z<='1';
                if X='0' then nextState<=8;
                else nextState<=1;
                end if;
            when others=>null;
        end case;
    end process;
    
    --nextStateRegister
    process(CLK,reset)
    begin
		if reset='0' then State<=0;
		
        elsif CLK'event and CLK='1' then
            State<=nextState;
        end if;
    end process;
end architecture Behavior;
       
                
                
                
                
                