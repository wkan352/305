library IEEE;
use  IEEE.STD_LOGIC_1164.all;


entity lfsr is 
port (pipe_passed : in  std_logic;     
      PIPE_RANDOM 		    : OUT STD_LOGIC_VECTOR(8 DOWNTO 0));
end entity lfsr;

architecture behaviour of lfsr is  

  signal r_lfsr                 : std_logic_vector (8 downto 0) := "101011110";

begin  
PIPE_RANDOM  <= r_lfsr(8 downto 0);

p_lfsr : process (pipe_passed) begin 

  if (pipe_passed='1') then 
      r_lfsr(8) <= r_lfsr(0);
      r_lfsr(7) <= r_lfsr(8) xor r_lfsr(0);
      r_lfsr(6) <= r_lfsr(7);
      r_lfsr(5) <= r_lfsr(6);
      r_lfsr(4) <= r_lfsr(5);
      r_lfsr(3) <= r_lfsr(4);
      r_lfsr(2) <= r_lfsr(3);
      r_lfsr(1) <= r_lfsr(2);
      r_lfsr(0) <= r_lfsr(1);
    end if; 
end process p_lfsr; 

end architecture behaviour;