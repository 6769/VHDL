library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; -- to use unsigned type 

entity UART_Receiver is
port(RxD, BclkX8, sysclk, rst_b, RDRF: in std_logic;
     RDR: out unsigned(7 downto 0);
     setRDRF, setOE, setFE: out std_logic);
end UART_Receiver;

architecture rcvr of UART_Receiver is
  type stateType is (IDLE, START_DETECTED, RECV_DATA);
  signal state, nextstate: stateType;
  signal RSR: unsigned(7 downto 0);   -- receive shift register
  signal ct1 : integer range 0 to 7;   -- indicates when to read the RxD input
  signal ct2 : integer range 0 to 8;   -- counts number of bits read
  signal inc1, inc2, clr1, clr2, shftRSR, loadRDR: std_logic;
  signal BclkX8_Dlayed, BclkX8_rising: std_logic;
begin
  BclkX8_rising <= BclkX8 and (not BclkX8_Dlayed);
    -- indicates the rising edge of bitX8 clock
  Rcvr_Control: process(state, RxD, RDRF, ct1, ct2, BclkX8_rising)
  begin
    -- reset control signals
    inc1 <= '0'; inc2 <= '0'; clr1 <= '0'; clr2 <= '0';
    shftRSR <= '0'; loadRDR <= '0'; setRDRF <= '0'; setOE <= '0'; setFE <= '0';
    case state is
      when IDLE =>
        if (RxD = '0') then nextstate <= START_DETECTED;
        else nextstate <= IDLE;
        end if;
      when START_DETECTED =>
        if (BclkX8_rising = '0') then nextstate <= START_DETECTED;
        elsif (RxD = '1') then clr1 <= '1'; nextstate <= IDLE;
        elsif (ct1 = 3) then clr1 <= '1'; nextstate <= RECV_DATA;
        else inc1 <= '1'; nextstate <= START_DETECTED;
        end if;
      when RECV_DATA =>
        if (BclkX8_rising = '0') then nextstate <= RECV_DATA;
        else inc1 <= '1';
          if (ct1 /= 7) then nextstate <= RECV_DATA;
            -- wait for 8 clock cycles
          elsif (ct2 /= 8) then
            shftRSR <= '1'; inc2 <= '1'; clr1 <= '1'; -- read next data bit
            nextstate <= RECV_DATA;
          else
            nextstate <= IDLE;
            setRDRF <= '1'; clr1 <= '1'; clr2 <= '1';
            if (RDRF = '1') then setOE <= '1';   -- overrun error
            elsif (RxD = '0') then setFE <= '1'; -- framing error
            else loadRDR <= '1';                 -- load recv data register
            end if;
          end if;
        end if;
    end case;
  end process;
  
  Rcvr_update: process(sysclk, rst_b)
  begin
    if (rst_b = '0') then state <= IDLE; BclkX8_Dlayed <= '0';
      ct1 <= 0; ct2 <= 0;
    elsif (sysclk'event and sysclk = '1') then
      state <= nextstate;
      if (clr1 = '1') then ct1 <= 0; elsif (inc1 = '1') then
        ct1 <= ct1 + 1;
      end if;
      if (clr2 = '1') then ct2 <= 0; elsif (inc2 = '1') then
        ct2 <= ct2 + 1;
      end if;
      if (shftRSR = '1') then RSR <= RxD & RSR(7 downto 1);
      end if;
      -- update shift reg.
      if (loadRDR = '1') then RDR <= RSR;
      end if;
      BclkX8_Dlayed <= BclkX8;   -- BclkX8 delayed by 1 sysclk
    end if;
  end process;
end rcvr;
