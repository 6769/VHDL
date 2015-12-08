library ieee;
entity NbitCounter is 
	port(
	clear:in bit:='1';
    clk,enable:in bit ;
	Q:buffer bit_vector(15 downto 0):=( others=>'0')   );
    --Q:buffer bit_vector(15 downto 0):="1111111111111100");
end entity NbitCounter;

architecture bit16counter of NbitCounter is

	signal T:bit_vector(15 downto 0);
	signal QN:bit_vector(15 downto 0);
begin
	T(0)<=enable;
    QN<=not Q;
    T(1)<=Q(0)and T(0);
    T(2)<=Q(1)and T(1);
    T(3)<=Q(2)and T(2);
    T(4)<=Q(3)and T(3);
    T(5)<=Q(4)and T(4);
    T(6)<=Q(5)and T(5);
    T(7)<=Q(6)and T(6);
    T(8)<=Q(7)and T(7);
    T(9)<=Q(8)and T(8);
    T(10)<=Q(9)and T(9);
    T(11)<=Q(10)and T(10);
    T(12)<=Q(11)and T(11);
    T(13)<=Q(12)and T(12);
    T(14)<=Q(13)and T(13);
    T(15)<=Q(14)and T(14);
    
	process(clk,clear)
	begin
		if clear='0' then Q<=(others=>'0');
		elsif (clk'event and clk='1') then
				Bit16Loop:for i in 0 to 15 loop
                    if T(i)='1' then	Q(i) <=QN(i);
                    end if;
--                    if i>0		then	T(i)<=Q(i-1)and T(i-1);
--                    end if;
				end loop;
		end if;
	end process;
end architecture bit16counter;