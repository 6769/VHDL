--partA
--file for first VHDL Documents.!!!
entity NumberAnDisplay is
	port(
		-- Input ports
		V	: in  bit_vector(3 downto 0);
		-- Output ports
		z	: buffer bit;
		M	: buffer bit_vector(3 downto 0);
		
		-- 7 Segment Display
		segment7:out bit_vector(6 downto 0);
		--segment7:out bit_vector();
		segment7_point:out bit :='1';
		
		segment7_1:out bit_vector(6 downto 0);
		segment7_1_point:out bit :='1'
	);
end NumberAnDisplay;

architecture CircuitA_Mux of NumberAnDisplay is 
	signal midM : bit_vector(2 downto 0);
	--assignment about <:='0000'> correspond?
begin
	z<= V(3)and (V(2)or V(1));
	--circuitA part 
	midM(0)<=V(0);
	midM(1)<=not V(1);
	midM(2)<=V(2)and V(1);

	--Multiplexer part 
	M(3)<=(not z) and V(3) ;
	M(2)<=((not z) and V(2)) or (z and midM(2));
	M(1)<=((not z) and V(1)) or (z and midM(1));
	M(0)<=((not z) and V(0)) or (z and midM(0));
	
	--7 Segment Display
	process (M)
	BEGIN
		case  M is
			when "0000"=> segment7 <="1000000";  -- '0'
			when "0001"=> segment7 <="1111001";  -- '1'
			when "0010"=> segment7 <="0100100";  -- '2'
			when "0011"=> segment7 <="0110000";  -- '3'
			when "0100"=> segment7 <="0011001";  -- '4' 
			when "0101"=> segment7 <="0010010";  -- '5'
			when "0110"=> segment7 <="0000010";  -- '6'
			when "0111"=> segment7 <="1111000";  -- '7'
			when "1000"=> segment7 <="0000000";  -- '8'
			when "1001"=> segment7 <="0010000";  -- '9'
			 --nothing is displayed when a number more than 9 is given as input. 
			when others=> segment7 <="1111111"; 
		end case;
	end process;
	
	process (z)
	BEGIN		
		case  z is
			when '0'=> segment7_1 <="1000000";  -- '0'
			when '1'=> segment7_1 <="1111001";  -- '1'
			--nothing is displayed when a number more than 9 is given as input. 
			when others=> segment7 <="1111111"; 
		end case;
	end process;
end CircuitA_Mux;

