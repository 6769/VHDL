library ieee;
use ieee.numeric_bit.all;
use ieee.std_logic_1164.all;


entity FSM_core is
    port(X:in bit;
	CLK:in bit;
	reset:in bit;
	stateout:out integer range 0 to 8;
	Z:out bit);
end entity FSM_core;

architecture Behavior of FSM_core is

signal State,nextState:bit_vector(3 downto 0);
alias Q0:bit is State(0);
alias Q1:bit is State(1);
alias Q2:bit is State(2);
alias Q3:bit is State(3);

begin
    stateout<=to_integer(unsigned(State));
    Z<=(Q3 or Q2 )and not Q1 and not Q0;
    --Q0`=x(q0'q1'+q0q2+q1q0')+x'(q3'q2'+q2q0')
    nextState(0)<=(X and ((not Q0 and not Q2) or (Q0 and Q2)or (Q1 and not Q0)))or (not X and ((not Q3 and not Q2)or (Q2 and not Q0 )));
    nextState(1)<=(x and ((Q1 and not Q0 and not Q2)or (not Q1 and Q0 and not Q2)))or(not x and ((not Q1 and Q0 and Q2)or (Q1 and not Q0 and Q2) )) ;
    nextState(2)<=(X and ( (not Q1 and not Q0 and Q2) or (Q1 and Q0 and not Q2) ))or(not X and ( (not Q3 and not Q2) or (Q1 and not Q0 ) or (not Q1 and Q2) ));
    nextState(3)<=not X and ( (Q3 and not Q2) or (Q1 and Q0 and Q2) );
    
    process(CLK,reset)
    begin
        if reset='0' then State<="0000";
        elsif CLK'event and CLK='1' then 
        State<=nextState;
        end if;
    end process;
    
    
    
    
end architecture Behavior;
       