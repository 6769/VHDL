
--------------------------------------------------------------
 ------------------------------------------------------------
  --                FSM_core.vhd
 ------------------------------------------------------------
--------------------------------------------------------------

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
       
                
                
                
                
                

--------------------------------------------------------------
 ------------------------------------------------------------
  --                View_input.vhd
 ------------------------------------------------------------
--------------------------------------------------------------

entity View_input is 
	port (reset:in bit;
		w:  in bit;
		clk:in bit;
		z: out bit;
		state8_0:out bit_vector(8 downto 0));--LED Red for showing State table
end entity View_input;

architecture match of View_input is
component FSM_core
	port(
	X:    in bit;
	CLK:  in bit;
	reset:in bit;
	stateout:out integer range 0 to 8;
	Z:   out bit);
end component;
signal  stateout:integer range 0 to 8;
begin
	lable_1:fsm_core port map(w,clk,reset,stateout,z);
	with stateout select					--mux choice
		state8_0 <=	"000000001" when 0,
					"000000010" when 1,
					"000000100" when 2,
					"000001000" when 3,
					"000010000" when 4,
					"000100000" when 5,
					"001000000" when 6,
					"010000000" when 7,
					"100000000" when 8;
end architecture match;

