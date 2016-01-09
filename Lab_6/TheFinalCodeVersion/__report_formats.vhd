--------------------------------------------------------------
 ------------------------------------------------------------
  --                Addsub.vhd
 ------------------------------------------------------------
--------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity Addsub_Unit is
    Generic (n : Integer := 16);
    port(
        a,b:            in std_logic_vector(n-1 downto 0);
        select_add_sub: in std_logic;
        result:         buffer std_logic_vector(n-1 downto 0)
        );
end entity Addsub_Unit;

architecture Behavior of Addsub_Unit is

begin
    process(select_add_sub,a,b)
    begin
        case select_add_sub is
            when '0'=>
                result<=a+b;
            when '1'=>
                result<=a-b;
            when others=>
                result<=(others=>'Z');
        end case;
    
    end process;


end architecture Behavior;

--------------------------------------------------------------
 ------------------------------------------------------------
  --                Control_unit.vhd
 ------------------------------------------------------------
--------------------------------------------------------------

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


--------------------------------------------------------------
 ------------------------------------------------------------
  --                dec3to8.vhd
 ------------------------------------------------------------
--------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
entity dec3to8 is
	port (
		W : in STD_LOGIC_VECTOR(2 downto 0);
		En : in STD_LOGIC;
		Y : out STD_LOGIC_VECTOR(0 to 7)
	);
end dec3to8;

architecture Behavior of dec3to8 is
begin
	process (W, En)
	begin
		if En = '1' then
			case W is
				when "000" => Y <= "10000000";
				when "001" => Y <= "01000000";
				when "010" => Y <= "00100000";
				when "011" => Y <= "00010000";
				when "100" => Y <= "00001000";
				when "101" => Y <= "00000100";
				when "110" => Y <= "00000010";
				when "111" => Y <= "00000001";
                when others=> null;
			end case;
		else
			Y <= "00000000";
		end if;
	end process;
end Behavior;

--------------------------------------------------------------
 ------------------------------------------------------------
  --                multiplexers.vhd
 ------------------------------------------------------------
--------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;


entity multiplexers is
    generic(
        N:integer:=2;--number of register;
        n_multi:integer:=16 --bus width
        );
    
    port(
        DataIn,reg_G:in std_logic_vector(n_multi-1 downto 0);
        reg0:       in std_logic_vector(n_multi-1 downto 0);
        reg1:       in std_logic_vector(n_multi-1 downto 0);
        
        
        control_reg:in std_logic_vector( 0 to N-1);
        control_GDi:in std_logic_vector(1 downto 0);
        out_to_bus: buffer std_logic_vector(n_multi-1 downto 0)
    );
end entity multiplexers;

architecture choice of multiplexers is
    signal mid_choice:std_logic_vector(N+2-1 downto 0);
begin
    mid_choice<=control_reg&control_GDi;--0~7|G|Din--
	
--    out_to_bus<= DataIn when control_GDi(0)='1'
--            else reg_G  when control_GDi(1)='1'
--            else reg0   when control_reg(0)='1'
--            else reg1   when control_reg(1)='1'
--            ;--else (others=>'Z');

	process(mid_choice,reg0,reg1,reg_G,DataIn)
	begin
		case mid_choice is
			
			when "1000"=>
				out_to_bus<=reg0;
			when "0100"=>
				out_to_bus<=reg1;
			when "0010"=>
				out_to_bus<=reg_G;
			when others=>
			--when "0001"=>
				out_to_bus<=DataIn;
			--when others=>
				
		end case;
	end process;
end architecture choice;


--------------------------------------------------------------
 ------------------------------------------------------------
  --                regn.vhd
 ------------------------------------------------------------
--------------------------------------------------------------


Library ieee;
Use ieee.std_logic_1164.All;
Entity regn Is
	Generic (n : Integer := 16);
	Port (
		R : In STD_LOGIC_VECTOR(n - 1 Downto 0);
		Rin, Clock : In STD_LOGIC;
		Q : Buffer STD_LOGIC_VECTOR(n - 1 Downto 0)
	);
End regn;
Architecture Behavior Of regn Is
Begin
	Process (Clock)
	Begin
		If Clock'EVENT And Clock = '1' Then
			If Rin = '1' Then
				Q <= R;
			End If;
		End If;
	End Process;
End Behavior;

--------------------------------------------------------------
 ------------------------------------------------------------
  --                upcount.vhd
 ------------------------------------------------------------
--------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
entity upcount is
	port (
		Clear, Clock : in STD_LOGIC;
		Q : out STD_LOGIC_VECTOR(1 downto 0)
	);
end upcount;

architecture Behavior of upcount is
	signal Count : STD_LOGIC_VECTOR(1 downto 0);
begin
	process (Clock)
	begin
		if (Clock'EVENT and Clock = '1') then
			if Clear = '1' then
				Count <= "00";
			else
				Count <= Count + 1;
			end if;
		end if;
	end process;
	Q <= Count;
end Behavior;

--------------------------------------------------------------
 ------------------------------------------------------------
  --                View.vhd
 ------------------------------------------------------------
--------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity View is
    port (
        DIN : in STD_LOGIC_VECTOR(15 downto 0);
        Resetn, Clock, Run : in STD_LOGIC;
        Done : out STD_LOGIC;
        BusWires : buffer STD_LOGIC_VECTOR(15 downto 0)
    );
end View;

architecture Behavior of View is
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
    
    component regn      --usual register
        Generic (n : Integer := 16);
        Port (
            R : In STD_LOGIC_VECTOR(n - 1 Downto 0);
            Rin, Clock : In STD_LOGIC;
            Q : Buffer STD_LOGIC_VECTOR(n - 1 Downto 0)
        );
    end component;
    
    component upcount
        port (
            Clear, Clock : in STD_LOGIC;
            Q : out STD_LOGIC_VECTOR(1 downto 0)
        );
    end component;
    
    component Addsub_Unit 
        Generic (n : Integer := 16);
        port(
            a,b:            in std_logic_vector(n-1 downto 0);
            select_add_sub: in std_logic;
            result:         buffer std_logic_vector(n-1 downto 0)
            );
    end component;
    
    component multiplexers
        generic(
            N:integer:=2;--number of register;
            n_multi:integer:=16 --bus width
            );
        
        port(
            DataIn,reg_G:in std_logic_vector(n_multi-1 downto 0);
            reg0:       in std_logic_vector(n_multi-1 downto 0);
            reg1:       in std_logic_vector(n_multi-1 downto 0);
            
            
            control_reg:in std_logic_vector( 0 to N-1);
            control_GDi:in std_logic_vector(1 downto 0);
            out_to_bus: buffer std_logic_vector(n_multi-1 downto 0)
        );
    end component;
	
	component Control_unit
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
	end component;
    --declare signals
    --
    --
	subtype regwidth is std_logic_vector(15 downto 0);
	signal R0,R1,A,G:regwidth;
	---------------------------------
	--Control_unit output
	---------------------------------
	--IR control_unit
	signal	IRset: std_logic_vector(0 to 8);--instruction length =9 bits
	signal	IRin:  std_logic;
		
		--multiplexer
	signal	Riout: std_logic_vector(0 to 7);
	signal	Gout,DINout: std_logic;
		
		--Register Data in
	signal	Rin:  std_logic_vector(0 to 7);
	signal	Ain,Gin:  std_logic;
		
		--ALU control_unit
	signal	AddSub:  std_logic;
		
		--Counter state
	signal	Tstep_Q:  std_logic_vector(1 downto 0);
	signal	Clear:  std_logic;
		
		--singular control signal 
	--signal	Run,Resetn:  std_logic;
	--signal	Done:  std_logic;
	-------------------------------------
	signal	 ALU_result:std_logic_vector(15 downto 0);
begin

	Tstep : upcount port map(Clear, Clock , Tstep_Q);
	--                    Din,      RinControl,Clk,ROut
    reg_0 : regn port map(BusWires, Rin(0), Clock, R0);
    reg_1 : regn port map(BusWires, Rin(1), Clock, R1);
    reg_A : regn port map(BusWires, Ain,    Clock, A );
    reg_G : regn port map(ALU_result, Gin,  Clock, G );
    reg_IR: regn generic map(9) port map(DIN(15 downto 7),IRin,Clock,IRset);
    ALU_Unit:
            Addsub_Unit port map(A,  BusWires,AddSub, ALU_result);
    --instantiate other registers and the adder/subtracter unit
    Multiplexer_Unit:
            multiplexers generic map(N=>2,n_multi=>16) port map(DIN,G,R0,R1,Riout(0 to 1) ,Gout&DINout,BusWires);
    --define the bus
	
	--Control_unit
	--------------------
	Control_unit_label:Control_unit port map(
		IRset,--instruction length =9 bits
		IRin,
		
		--multiplexer
		Riout,
		Gout,DINout,
		
		--Register Data in
		Rin,
		Ain,Gin,
		
		--ALU control_unit
		AddSub,
		
		--Counter state
		Tstep_Q,
		Clear,
		--singular control signal 
		Run,Resetn,
		Done
	);
	
	--------------------
end  architecture Behavior;
