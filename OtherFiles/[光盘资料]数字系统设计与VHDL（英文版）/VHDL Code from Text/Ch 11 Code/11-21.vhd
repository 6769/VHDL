library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; -- use this if unsigned type is used.

entity UART_Transmitter is
  port(Bclk, sysclk, rst_b, TDRE, loadTDR: in std_logic;
       DBUS: in unsigned(7 downto 0);
       setTDRE, TxD: out std_logic);
end UART_Transmitter;

architecture xmit of UART_Transmitter is
  type stateType is (IDLE, SYNCH, TDATA);
  signal state, nextstate: stateType;
  signal TSR: unsigned(8 downto 0);   -- Transmit Shift Register
  signal TDR: unsigned(7 downto 0);   -- Transmit Data Register
  signal Bct: integer range 0 to 9;   -- counts number of bits sent
  signal inc, clr, loadTSR, shftTSR, start: std_logic;
  signal Bclk_rising, Bclk_Dlayed: std_logic;
begin
  TxD <= TSR(0);
  setTDRE <= loadTSR;
  Bclk_rising <= Bclk and (not Bclk_Dlayed);
  -- indicates the rising edge of bit clock
  
  Xmit_Control: process(state, TDRE, Bct, Bclk_rising)
  begin
    inc <= '0'; clr <= '0'; loadTSR <= '0'; shftTSR <= '0'; start <= '0';
    -- reset control signals
    case state is
      when IDLE =>
        if (TDRE = '0' ) then
          loadTSR <= '1'; nextstate <= SYNCH;
        else nextstate <= IDLE;
        end if;
      when SYNCH =>   -- synchronize with the bit clock
        if (Bclk_rising = '1') then 
          start <= '1'; nextstate <= TDATA;
        else nextstate <= SYNCH;
        end if;
      when TDATA =>
        if (Bclk_rising = '0') then nextstate <= TDATA;
        elsif (Bct /= 9) then
          shftTSR <= '1'; inc <= '1'; nextstate <= TDATA;
        else clr <= '1'; nextstate <= IDLE;
        end if;
    end case;
  end process;
  
  Xmit_update: process(sysclk, rst_b)
  begin
    if (rst_b = '0') then
      TSR <= "111111111"; state <= IDLE; Bct <= 0; Bclk_Dlayed <= '0';
    elsif (sysclk'event and sysclk = '1') then
      state <= nextstate;
      if (clr = '1') then Bct <= 0;
      elsif (inc = '1') then
        Bct <= Bct + 1;
      end if;
      if (loadTDR = '1') then TDR <= DBUS;
      end if;
      if (loadTSR = '1') then TSR <= TDR & '1';
      end if;
      if (start = '1') then TSR(0) <= '0';
      end if;
      if (shftTSR = '1') then TSR <= '1' & TSR(8 downto 1);
      end if;
      -- shift out one bit
      Bclk_Dlayed <= Bclk;   -- Bclk delayed by 1 sysclk
    end if;
  end process;
end xmit;
