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
