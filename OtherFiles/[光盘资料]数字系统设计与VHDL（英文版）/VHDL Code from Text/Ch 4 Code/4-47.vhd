entity scanner is
  port(R0, R1, R2, R3, CLK: in bit;
       C0, C1, C2: inout bit;
       N0, N1, N2, N3, V: out bit);
end scanner;

architecture behavior of scanner is
signal QA, K ,Kd: bit;
signal state, nextstate: integer range 0 to 5;
begin
  K <= R0 or R1 or R2 or R3;   -- this is the decoder section
  N3 <= (R2 and not C0) or (R3 and not C1);
  N2 <= R1 or (R2 and C0);
  N1 <= (R0 and not C0) or (not R2 and C2) or (not R1 and not R0 and C0);
  N0 <= (R1 and C1) or (not R1 and C2) or (not R3 and not R1 and not C1);

  process(state, R0, R1, R2, R3, C0, C1, C2, K, Kd, QA)
  begin
    C0 <= '0'; C1 <= '0'; C2 <= '0'; V <= '0';
    case state is
      when 0 => nextstate <= 1;
      when 1 => C0 <= '1'; C1 <= '1'; C2 <= '1';
        if (Kd and K) = '1' then nextstate <= 2;
        else nextstate <= 1;
        end if;
      when 2 => C0 <= '1';
        if (Kd and K) = '1' then V <= '1'; nextstate <= 5;
        elsif K = '0' then nextstate <= 3;
        else nextstate <= 2;
        end if;
      when 3 => C1 <= '1';
        if (Kd and K) = '1' then V <= '1'; nextstate <= 5;
        elsif K = '0' then nextstate <= 4;
        else nextstate <= 3;
        end if;
      when 4 => C2 <= '1';
        if (Kd and K) = '1' then V <= '1'; nextstate <= 5;
        else nextstate <= 4;
        end if;
      when 5 => C0 <= '1'; C1 <= '1'; C2 <= '1';
        if Kd = '0' then nextstate <= 1;
        else nextstate <= 5;
        end if;
    end case;
  end process;

  process(CLK)
  begin
    if CLK = '1' and CLK'EVENT then
      state  <= nextstate;
      QA <= K;
      Kd <= QA;
    end if;
  end process;
end behavior;