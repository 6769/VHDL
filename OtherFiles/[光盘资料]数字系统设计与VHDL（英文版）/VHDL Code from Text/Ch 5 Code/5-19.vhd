entity tester is
end tester;

architecture test of tester is
component GameTest
  port(Rb, Reset: out bit;
       Sum: out integer range 2 to 12;
       CLK: inout bit;
       Roll, Win, Lose: in bit);
end component;

component DiceGame 
  port(Rb, Reset, CLK: in bit;
       Sum: in integer range 2 to 12;
       Roll, Win, Lose: out bit);
end component;

signal rb1, reset1, clk1, roll1, win1, lose1: bit;
signal sum1: integer range 2 to 12;
begin 
  Dice: Dicegame port map (rb1, reset1, clk1, sum1, roll1, win1, lose1);
  Dicetest: GameTest port map (rb1, reset1, sum1, clk1, roll1, win1, lose1);
end test;
