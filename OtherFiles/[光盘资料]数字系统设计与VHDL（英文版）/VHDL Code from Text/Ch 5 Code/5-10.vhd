entity Mult is
  port(CLK, St, K, M: in bit;
       Load, Sh, Ad, Done: out bit);
end Mult;

architecture SMbehave of Mult is
signal State, Nextstate: integer range 0 to 3;
begin
  process(St, K, M, State)                  -- start if state or inputs change
  begin
    Load <= '0'; Sh <= '0'; Ad <= '0'; Done <= '0';
    case State is
      when 0 =>
        if St = '1' then                    -- St (state 0)
          Load <= '1';
          Nextstate <= 1;
        else Nextstate <= 0;                -- St'
        end if;
      when 1 =>
        if M = '1' then                     -- M (state 1)
          Ad <= '1';
          Nextstate <= 2;
        else                                -- M'
          Sh <= '1';
          if K = '1' then Nextstate <= 3;   -- K
          else Nextstate <= 1;              -- K'
          end if;
        end if;
      when 2 =>
        Sh <= '1';                          -- (state 2)
        if K = '1' then Nextstate <= 3;     -- K
        else Nextstate <= 1;                -- K'
        end if;
      when 3 =>
        Done <= '1';                        -- (state 3)
        Nextstate <= 0;
    end case;
  end process;
  process(CLK)
  begin 
    if CLK = '1' and CLK'event then
      State <= Nextstate;                   -- update state on rising edge
    end if;
  end process;
end SMbehave;
