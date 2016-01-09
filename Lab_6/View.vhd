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