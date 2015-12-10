library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity UART is
  port(SCI_sel, R_W, clk, rst_b, RxD: in std_logic;
       ADDR2: in unsigned(1 downto 0);
       DBUS: inout unsigned(7 downto 0);
       SCI_IRQ, TxD, RDRF_out, Bclk_out, TDRE_out: out std_logic);
end UART;

architecture uart1 of UART is
  component UART_Receiver
    port(RxD, BclkX8, sysclk, rst_b, RDRF: in std_logic;
         RDR: out unsigned(7 downto 0);
         setRDRF, setOE, setFE: out std_logic);
  end component;
  component UART_Transmitter
    port(Bclk, sysclk, rst_b, TDRE, loadTDR: in std_logic;
         DBUS: in unsigned(7 downto 0);
         setTDRE, TxD: out std_logic);
  end component;
  component clk_divider
    port(Sysclk, rst_b: in std_logic;
         Sel: in unsigned(2 downto 0);
         BclkX8: buffer std_logic; Bclk: out std_logic);
  end component;
  signal RDR: unsigned(7 downto 0);   -- Receive Data Register
  signal SCSR: unsigned(7 downto 0);   -- Status Register
  signal SCCR: unsigned(7 downto 0);   -- Control Register
  signal TDRE, RDRF, OE, FE, TIE, RIE: std_logic;
  signal BaudSel: unsigned(2 downto 0);
  signal setTDRE, setRDRF, setOE, setFE, loadTDR, loadSCCR: std_logic;
  signal clrRDRF, Bclk, BclkX8, SCI_Read, SCI_Write: std_logic;
begin
  RCVR: UART_Receiver port map(RxD, BclkX8, clk, rst_b, RDRF, RDR,
                               setRDRF, setOE, setFE);
  XMIT: UART_Transmitter port map(Bclk, clk, rst_b, TDRE, loadTDR,
                                  DBUS, setTDRE, TxD);
  CLKDIV: clk_divider port map(clk, rst_b, BaudSel, BclkX8, Bclk);
  RDRF_out <= RDRF; Bclk_out <= Bclk; TDRE_out <= TDRE; --(1)
  -- This process updates the control and status registers
  process(clk, rst_b)
  begin
    if (rst_b = '0') then
      TDRE <= '1'; RDRF <= '0'; OE<= '0'; FE <= '0';
      TIE <= '0'; RIE <= '0';
    elsif (rising_edge(clk)) then
      TDRE <= (setTDRE and not TDRE) or (not loadTDR and TDRE);
      RDRF <= (setRDRF and not RDRF) or (not clrRDRF and RDRF);
      OE <= (setOE and not OE) or (not clrRDRF and OE);
      FE <= (setFE and not FE) or (not clrRDRF and FE);
      if (loadSCCR = '1') then TIE <= DBUS(7); RIE <= DBUS(6);
        BaudSel <= DBUS(2 downto 0);
      end if;
    end if;
  end process;
  
  -- IRQ generation logic
  SCI_IRQ <= '1' when ((RIE = '1' and (RDRF = '1' or OE = '1')) or
                      (TIE = '1' and TDRE = '1'))
                 else '0';
  -- Bus Interface
  SCSR <= TDRE & RDRF & "0000" & OE & FE;
  SCCR <= TIE & RIE & "000" & BaudSel;
  SCI_Read <= '1' when (SCI_sel = '1' and R_W = '0') else '0';
  SCI_Write <= '1' when (SCI_sel = '1' and R_W = '1') else '0';
  clrRDRF <= '1' when (SCI_Read = '1' and ADDR2 = "00") else '0';
  loadTDR <= '1' when (SCI_Write = '1' and ADDR2 = "00") else '0';
  loadSCCR <= '1' when (SCI_Write = '1' and ADDR2 = "10") else '0';
  DBUS <= "ZZZZZZZZ" when (SCI_Read = '0')   -- tristate bus when not reading
          else RDR when (ADDR2 = "00")   -- write appropriate register to the bus
          else SCSR when (ADDR2 = "01")
          else SCCR;   -- dbus = sccr, if ADDR2 is "10" or "11"
end uart1;
