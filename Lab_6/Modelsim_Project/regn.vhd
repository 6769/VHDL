
Library ieee;
Use ieee.std_logic_1164.All;
Entity regn Is
	Generic (n : Integer := 16);
	Port (
		R : In STD_LOGIC_VECTOR(n - 1 Downto 0);
		Rin, Clock : In STD_LOGIC;
		Q : Buffer STD_LOGIC_VECTOR(n - 1 Downto 0)
	);
End regn;
Architecture Behavior Of regn Is
Begin
	Process (Clock)
	Begin
		If Clock'EVENT And Clock = '1' Then
			If Rin = '1' Then
				Q <= R;
			End If;
		End If;
	End Process;
End Behavior;