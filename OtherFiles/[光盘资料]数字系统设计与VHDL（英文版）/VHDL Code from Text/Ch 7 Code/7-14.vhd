library IEEE;
use IEEE.numeric_bit.all;

entity FPADD is
  port(CLK, St: in bit; done, ovf, unf: out bit; 
       FPinput: in unsigned(31 downto 0); -- IEEE single precision FP format
       FPsum: out unsigned(31 downto 0)); -- IEEE single precision FP format
end FPADD;

architecture FPADDER of FPADD is
 -- F1 and F2 store significand with leading 1 and trailing 0's added
signal F1, F2: unsigned(25 downto 0); 
signal E1, E2: unsigned(7 downto 0);  -- exponents
signal S1, S2, FV, FU: bit;
 -- intermediate results for 2's complement addition
signal F1comp, F2comp, Addout, Fsum: unsigned(27 downto 0);
signal State: integer range 0 to 6;
begin  -- convert fractions to 2's comp and add
  F1comp <= not("00" & F1) + 1 when S1 = '1' else "00" & F1;
  F2comp <= not("00" & F2) + 1 when S2 = '1' else "00" & F2;
  Addout <= F1comp + F2comp;
   -- find magnitude of sum
  Fsum <= Addout when Addout(27) = '0' else not Addout + 1;
  FV <= Fsum(27) xor Fsum(26);        -- fraction overflow
  FU <= not F1(25);                   -- fraction underflow
  FPsum <= S1 & E1 & F1(24 downto 2); -- pack output word
  process(CLK)
  begin
    if CLK'event and CLK = '1' then
      case State is
        when 0 =>
          if St = '1' then -- load E1 and F1
            E1 <= FPinput(30 downto 23); S1 <= FPinput(31);
            F1(24 downto 0) <= FPinput(22 downto 0) & "00";
            -- insert 1 in significand (or 0 if the input number is 0)
            if FPinput = 0 then F1(25) <= '0'; else F1(25) <= '1'; end if;
            done <= '0'; ovf <= '0'; unf <= '0'; State <= 1;
          end if;
        when 1 =>  -- load E2 and F2
          E2 <= FPinput(30 downto 23); S2 <= FPinput(31);
          F2(24 downto 0) <= FPinput(22 downto 0) & "00";
          if FPinput = 0 then F2(25) <= '0'; else F2(25) <= '1'; end if;
          State <= 2;
        when 2 =>  -- unnormalize fraction with smallest exponent
         if F1 = 0 or F2 = 0 then State <= 3;
         else
           if E1 = E2 then State <= 3;
           elsif E1 < E2 then
             F1 <= '0' & F1(25 downto 1); E1 <= E1 + 1; 
           else
             F2 <= '0' & F2(25 downto 1); E2 <= E2 + 1;
           end if;
         end if;
       when 3 => -- add fractions and check for fraction overflow
         S1 <= Addout(27);
         if FV = '0' then F1 <= Fsum(25 downto 0);
         else F1 <= Fsum(26 downto 1); E1 <= E1 + 1; end if;
         State <= 4;
       when 4 => -- check for sum of fractions = 0
         if F1 = 0 then E1 <= "00000000"; State <= 6;
         else State <= 5; end if;
       when 5 => -- normalize
         if E1 = 0 then unf <= '1'; State <= 6;
         elsif FU = '0' then State <= 6;
         else F1 <= F1(24 downto 0) & '0'; E1 <= E1 - 1;
         end if;
       when 6 => -- check for exponent overflow
         if E1 = 255 then ovf <= '1'; end if;
         done <= '1';
         State <= 0;
     end case;
    end if;
  end process;
end FPADDER;