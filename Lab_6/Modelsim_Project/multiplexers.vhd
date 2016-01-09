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
