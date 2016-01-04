entity Game is
  port(Rb, Reset, Clk: in bit;
       Win, Lose: out bit);
end Game;

architecture Play1 of Game is
component Counter
  port(Clk, Roll: in bit;
       Sum: out integer range 2 to 12);
end component;

component DiceGame 
  port(Rb, Reset, CLK: in bit;
       Sum: in integer range 2 to 12;
       Roll, Win, Lose: out bit);
end component;

signal roll1: bit;
signal sum1: integer range 2 to 12;
begin 
  Dice: Dicegame port map (Rb, Reset, Clk, sum1, roll1, Win, Lose);
  Count: Counter port map (Clk, roll1, sum1);
end Play1;
