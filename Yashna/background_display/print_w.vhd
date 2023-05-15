library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity print is
	port(
		pixel_fontrow : in std_logic_vector(2 downto 0);
		address : out std_logic_vector(5 downto 0) );
end entity print;

architecture behav of print is

begin
	address <= CONV_STD_LOGIC_VECTOR(23, 6);
					
end architecture behav;