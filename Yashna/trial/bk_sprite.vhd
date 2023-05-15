LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_SIGNED.all;
use IEEE.numeric_std.all;

ENTITY bg_sprite IS
PORT
(    pixel_row, pixel_column : IN std_logic_vector(9 DOWNTO 0);
 red_out, green_out, blue_out : OUT std_logic_vector(3 downto 0));
 
END bg_sprite;

architecture behavior of bg_sprite is
  signal Row, Column: integer range 0 to 1023;
 
  constant cutoffOne: std_logic_vector(10 DOWNTO 0) := "00110000110"; -- 390 pixels down
  constant cutoffTwo: std_logic_vector(10 DOWNTO 0) := "00110101110"; -- 430 pixels down
  -- Blue Sky RGB:      8 B C
  -- Green Bush:        9 D 8
  -- Yellow Ground RGB: D D 9

begin
  red_out   <= "1000" when ('0' & pixel_row < cutoffOne) else "1001" when ('0' & pixel_row < cutoffTwo) else "1101";
  green_out <= "1011" when ('0' & pixel_row < cutoffOne) else "1101" when ('0' & pixel_row < cutoffTwo) else "1101";
  blue_out  <= "1100" when ('0' & pixel_row < cutoffOne) else "1000" when ('0' & pixel_row < cutoffTwo) else "1001";
end behavior;