-- VHDL for Boundary Scan Architecture of Figure 10-15
 
entity BS_arch is
  generic (NCELLS: natural range 2 to 120 := 2); 
		 -- number of boundary scan cells
  port (TCK, TMS, TDI: in bit;
        TDO: out bit;
        BSRin: in bit_vector(1 to NCELLS);
        BSRout: inout bit_vector(1 to NCELLS);
        CellType: bit_vector(1 to NCELLS));
			-- '0' for input cell, '1' for output cell
end BS_arch;

architecture behavior of BS_arch is
  signal IR,IDR: bit_vector(1 to 3);          -- instruction registers
  signal BSR1,BSR2: bit_vector(1 to NCELLS);  -- boundary scan cells
  signal BYPASS: bit;                         -- bypass bit
  type TAPstate is (TestLogicReset, RunTest_Idle,
    SelectDRScan, CaptureDR, ShiftDR, Exit1DR, PauseDR, Exit2DR, UpdateDR,
    SelectIRScan, CaptureIR, ShiftIR, Exit1IR, PauseIR, Exit2IR, UpdateIR);
  signal St: TAPstate;                        -- TAP Controller State
begin
  process (TCK)
  begin
    if (TCK='1') then
     -- TAP Controller State Machine
      case St is
      when TestLogicReset =>  
	     if TMS='0' then St<=RunTest_Idle; else St<=TestLogicReset;  end if;
      when RunTest_Idle =>    
	     if TMS='0' then St<=RunTest_Idle; else St<=SelectDRScan;    end if;
      when SelectDRScan =>    
	     if TMS='0' then St<=CaptureDR;    else St<=SelectIRScan;    end if;
      when CaptureDR =>       
	     if IDR = "111" then BYPASS <= '0';
	     elsif IDR = "000" then  -- EXTEST (input cells capture pin data)
		     BSR1 <= (not CellType and BSRin) or (CellType and BSR1);
	     elsif IDR = "001" then  -- SAMPLE/PRELOAD 
		     BSR1 <= BSRin;  end if;  -- all cells capture cell input data
	     if TMS='0' then St<=ShiftDR;      else St<=Exit1DR;         end if;
      when ShiftDR =>         
	     if IDR = "111" then BYPASS <= TDI; -- shift data through bypass reg.
	       else BSR1 <= TDI & BSR1(1 to NCELLS-1); end if;
		      -- shift data into BSR
	     if TMS='0' then St<=ShiftDR;      else St<=Exit1DR;         end if;
      when Exit1DR =>         
	     if TMS='0' then St<=PauseDR;      else St<=UpdateDR;        end if;
      when PauseDR =>         
	     if TMS='0' then St<=PauseDR;      else St<=Exit2DR;         end if;
      when Exit2DR =>         
	     if TMS='0' then St<=ShiftDR;      else St<=UpdateDR;        end if;
      when UpdateDR =>        
	     if IDR = "000" then -- EXTEST (update output reg. for output cells)
	       BSR2 <= (CellType and BSR1) or (not CellType and BSR2);
	     elsif IDR = "001" then   -- SAMPLE/PRELOAD
	       BSR2 <= BSR1; end if;  -- update output reg. in all cells
	     if TMS='0' then St<=RunTest_Idle; else St<=SelectDRScan;    end if;
      when SelectIRScan =>    
	       if TMS='0' then St<=CaptureIR;   else St<=TestLogicReset; end if;
      when CaptureIR =>  
	       IR <= "001"; -- load 2 LSBs of IR with 01 as required by the standard
	       if TMS='0' then St<=ShiftIR;     else St<=Exit1IR;        end if;
      when ShiftIR =>         
	       IR <= TDI & IR(1 to 2);  -- shift in instruction code
	       if TMS='0' then St<=ShiftIR;     else St<=Exit1IR;        end if;
      when Exit1IR =>         
	       if TMS='0' then St<=PauseIR;     else St<=UpdateIR;       end if;
      when PauseIR =>         
	       if TMS='0' then St<=PauseIR;     else St<=Exit2IR;        end if;
      when Exit2IR =>         
	       if TMS='0' then St<=ShiftIR;     else St<=UpdateIR;       end if;
      when UpdateIR =>        
	       IDR <= IR;   -- update instruction decode register
	       if TMS='0' then St<=RunTest_Idle; else St<=SelectDRScan;  end if;
      end case;
    end if;
  end process;

  TDO <= BYPASS when St = ShiftDR and IDR = "111"  -- BYPASS
	   else BSR1(NCELLS) when St=ShiftDR   -- EXTEST or SAMPLE/PRELOAD
	   else IR(3) when St=ShiftIR;
	   
  BSRout <= BSRin when (St = TestLogicReset or not (IDR = "000"))
	     else BSR2;                          -- define cell outputs
end behavior;