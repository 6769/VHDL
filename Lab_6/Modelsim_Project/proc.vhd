library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity proc is
    port (
        DIN : in STD_LOGIC_VECTOR(15 downto 0);
        Resetn, Clock, Run : in STD_LOGIC;
        Done : buffer STD_LOGIC;
        BusWires : buffer STD_LOGIC_VECTOR(15 downto 0)
    );
end proc;
architecture Behavior of proc is
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
    
    component Addsub 
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
    --declare signals
    --
    --
    subtype regtype is std_logic_vector(15 downto 0);
    
    signal Tstep_Q:std_logic_vector(1 downto 0);
    signal High,Clear:std_logic;
    signal IR:std_logic_vector(1 to 9);
    signal Xreg,Yreg,Rin,Multiplexer_Reg:std_logic_vector(0 to 7);
    signal Ain,Gin,IRin,AddSub_ALU,Multiplexer_Gout,Multiplexer_Dinout:std_logic;
    
    signal R0,R1,A,ALU_result,G:regtype;

    signal I,X,Y:std_LOGIC_vector(1 to 3);

begin
    High <= '1';
	process(Run,Resetn)
	begin
		if Resetn='0' then	Clear <= '0';
		else Clear<='1';
		end if;
	end process;
	
	
    Tstep : upcount port map(Clear, Clock and Run, Tstep_Q);
    I <= IR(1 to 3);                                   --IR 1,2,3
    X <= IR(4 to 6);
    Y <= IR(7 to 9);
    decX : dec3to8    port map(X, High, Xreg);--IR 4,5,6
    decY : dec3to8    port map(Y, High, Yreg);--IR 7,8,9
    
    controlsignals: 
    process (Tstep_Q, I, Xreg, Yreg)
    begin
        --specify initial values
        Done<='0';
        Multiplexer_Dinout<='0';
        Multiplexer_Gout<='0';
        Multiplexer_Reg<=(others =>'0');
        Rin<=(others =>'0');
        Ain<='0';
        Gin<='0';
        IRin<='0';
        AddSub_ALU<='Z';
        
        case Tstep_Q is
            when "00" => -- store DIN in IR as long as Tstep_Q = 0
                IRin <= '1';
            when "01" => -- define signals in time step T1
                case I is
                    
                    when "000"=>--MV Rx,Ry;
                        Multiplexer_Reg<=Yreg;
                        Rin(to_integer(unsigned(X)))<='1';
                        Done<='1';
                    when "001"=>--MVi Rx,imd;
                        Multiplexer_Dinout<='1';
                        Rin(to_integer(unsigned(X)))<='1';
                        Done<='1';
                    when "010"=>--Add Rx,Ry;  Rxout,Ain;
                        Multiplexer_Reg<=Xreg;
                        Ain<='1';
                    when "011"=>--Sub Rx,Ry;  Rxout,Ain;
                        Multiplexer_Reg<=Xreg;
                        Ain<='1';
					when others=>null;
                end case;
            when "10" => -- define signals in time step T2
                case I is
                    when "010"=>--Add Rx,Ry;  Ryout,Gin;
                        Multiplexer_Reg<=Yreg;
                        AddSub_ALU<='0';
                        Gin<='1';
                    when "011"=>--Sub Rx,Ry;  Ryout,Gin;
                        Multiplexer_Reg<=Yreg;
                        AddSub_ALU<='1';
                        Gin<='1';
					when others=>null;
                end case;
            when "11" => -- define signals in time step T3
                case I is
                    when "010"=>--Add Rx,Ry;  Gout,Rxin;
                        Multiplexer_Gout<='1';
                        Rin(to_integer(unsigned(X)))<='1';
                        Done<='1';
                    when "011"=>--Sub Rx,Ry;  Gout,Rxin;
                        Multiplexer_Gout<='1';
                        Rin(to_integer(unsigned(X)))<='1';
                        Done<='1';
					when others=>null;
                end case;
        end case;
    end process;
    --                    Din,      RinControl,Clk,ROut
    reg_0 : regn port map(BusWires, Rin(0), Clock, R0);
    reg_1 : regn port map(BusWires, Rin(1), Clock, R1);
    reg_A : regn port map(BusWires, Ain,    Clock, A );
    reg_G : regn port map(ALU_result, Gin,  Clock, G );
    reg_IR: regn generic map(9) port map(DIN(15 downto 7),IRin,Clock,IR);
    ALU_Unit:
            Addsub port map(A,  BusWires,AddSub_ALU, ALU_result);
    --instantiate other registers and the adder/subtracter unit
    Multiplexer_Unit:
            multiplexers generic map(N=>2,n_multi=>16) port map(DIN,G,R0,R1,Multiplexer_Reg(0 to 1) ,Multiplexer_Gout&Multiplexer_Dinout,BusWires);
    --define the bus
end Behavior;