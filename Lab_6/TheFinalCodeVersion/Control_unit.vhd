library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity Control_unit is
	generic(
		--the number of universal register
		n_of_reg:integer:=8
	);
	port(
		--IR control_unit
		IRset:in std_logic_vector(0 to 8);--instruction length =9 bits
		IRin:out std_logic;
		
		--multiplexer
		Riout:out std_logic_vector(0 to n_of_reg-1);
		Gout,DINout:out std_logic;
		
		--Register Data in
		Rin:out std_logic_vector(0 to n_of_reg-1);
		Ain,Gin:out std_logic;
		
		--ALU control_unit
		AddSub:out std_logic;
		
		--Counter state
		Tstep_Q:in std_logic_vector(1 downto 0);
		Clear:out std_logic;
		
		--singular control signal 
		Run,Resetn:in std_logic;
		Done:buffer std_logic
		);
end entity Control_unit;
		
	
architecture behavior of Control_unit is
	--declare component
    --
    --
	component dec3to8   --InstructionSet decoder to multiplexers
        port (
            W : in STD_LOGIC_VECTOR(2 downto 0);
            En : in STD_LOGIC;
            Y : out STD_LOGIC_VECTOR(0 to 7)
        );
    end component;
	--declare signals
    --
    --
    subtype regwidth is std_logic_vector(15 downto 0);
	
	--InstructionSet
	signal IR:std_logic_vector(1 to 9);
	signal I,X,Y:std_LOGIC_vector(1 to 3);
	signal Xreg,Yreg:std_logic_vector(0 to 7);
begin
	Clear<= (not Resetn) or Done;
	--InstructionFormat I..X..Y..
	process(IRset,Run)
	begin
		if(Run='1' )then
			IR<=IRset;
		end if;
	end process;
	I <= IR(1 to 3);                          --IR 1,2,3
    X <= IR(4 to 6);
    Y <= IR(7 to 9);
	--InstructionDecoder to MUX
    decX : dec3to8    port map(X, '1', Xreg);--IR 4,5,6
    decY : dec3to8    port map(Y, '1', Yreg);--IR 7,8,9
	
	controlsignals: 
    process (Tstep_Q, I, Xreg, Yreg)--,Run)
    begin
		
        --specify initial values
        Done<='0';
		--to multiplexer
        DINout<='0';
        Gout<='0';
        Riout<=(others =>'0');
		--to register
        Rin<=(others =>'0');
        Ain<='0';
        Gin<='0';
        IRin<='0';
        AddSub<='Z';
        --if(Run='1')then 
        case Tstep_Q is
            when "00" => -- store DIN in IR as long as Tstep_Q = 0
                IRin <= '1';
            when "01" => -- define signals in time step T1
                case I is
                    
                    when "000"=>--MV Rx,Ry;
                        Riout<=Yreg;
                        Rin(to_integer(unsigned(X)))<='1';
                        Done<='1';
                    when "001"=>--MVi Rx,imd;
                        DINout<='1';
                        Rin(to_integer(unsigned(X)))<='1';
                        Done<='1';
                    when "010"=>--Add Rx,Ry;  Rxout,Ain;
                        Riout<=Xreg;
                        Ain<='1';
                    when "011"=>--Sub Rx,Ry;  Rxout,Ain;
                        Riout<=Xreg;
                        Ain<='1';
					when others=>null;
                end case;
            when "10" => -- define signals in time step T2
                case I is
                    when "010"=>--Add Rx,Ry;  Ryout,Gin;
                        Riout<=Yreg;
                        AddSub<='0';
                        Gin<='1';
                    when "011"=>--Sub Rx,Ry;  Ryout,Gin;
                        Riout<=Yreg;
                        AddSub<='1';
                        Gin<='1';
					when others=>null;
                end case;
            when "11" => -- define signals in time step T3
                case I is
                    when "010"=>--Add Rx,Ry;  Gout,Rxin;
                        Gout<='1';
                        Rin(to_integer(unsigned(X)))<='1';
                        Done<='1';
                    when "011"=>--Sub Rx,Ry;  Gout,Rxin;
                        Gout<='1';
                        Rin(to_integer(unsigned(X)))<='1';
                        Done<='1';
					when others=>null;
                end case;
        end case;
		--end if;
    end process;


end architecture behavior;
		
		
		