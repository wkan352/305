library ieee; 
use ieee.std_logic_1164.all;

entity lfsr is 
port (
  clk, enable, reset,sync_reset : in  std_logic;
  seed          		: in  std_logic_vector (8 downto 0);
  lfsr_pipe          		: out std_logic_vector (8 downto 0));
end lfsr;

architecture behaviour of lfsr is  

signal r_lfsr           : std_logic_vector (9 downto 1);

begin  
lfsr_pipe  <= r_lfsr(9 downto 1);

p_lfsr : process (clk,reset) begin 
seed ='111000111';
  if (reset= '0') then 
    r_lfsr   <= (others=>'1');
  elsif rising_edge(clk) then 
    if(sync_reset='1') then
      r_lfsr   <= seed;
    elsif (enable = '1') then 
      r_lfsr(9) <= r_lfsr(1);
      r_lfsr(8) <= r_lfsr(9) xor r_lfsr(1);
      r_lfsr(7) <= r_lfsr(8);
      r_lfsr(6) <= r_lfsr(7);
      r_lfsr(5) <= r_lfsr(6);
      r_lfsr(4) <= r_lfsr(5);
      r_lfsr(3) <= r_lfsr(4);
      r_lfsr(2) <= r_lfsr(3);
      r_lfsr(1) <= r_lfsr(2);
    end if; 
  end if; 
end process p_lfsr; 

end architecture behaviour;