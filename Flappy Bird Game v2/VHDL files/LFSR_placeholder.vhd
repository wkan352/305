LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_SIGNED.all;
USE IEEE.NUMERIC_STD.ALL;



entity lfsr is 
port (pipe_passed : in  std_logic;     
      PIPE_RANDOM 		    : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
		X_PIPE1, X_PIPE2, X_PIPE3 : OUT STD_LOGIC_VECTOR(9 DOWNTO 0));
end entity lfsr;

architecture behaviour of lfsr is  

  signal r_lfsr                 : std_logic_vector (8 downto 0) := "101011110";

begin  
PIPE_RANDOM  <= r_lfsr(8 downto 0);

X_PIPE1 <= std_logic_vector(to_unsigned(190, X_PIPE1'LENGTH));
X_PIPE2 <= std_logic_vector(to_unsigned(420, X_PIPE2'LENGTH));
X_PIPE3 <= std_logic_vector(to_unsigned(625, X_PIPE3'LENGTH));

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