library IEEE;
use  IEEE.STD_LOGIC_1164.all;

entity lfsr_output is 
port (enable,sync_reset : out  std_logic;)     
end entity lfsr_output;

architecture behaviour of lfsr_output is
enable<='1';
sync_reset<='1','0' after 50 ns;
end architecture behaviour;