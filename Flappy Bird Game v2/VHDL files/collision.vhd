LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY COLLISION IS
	PORT(	VERT_SYNC, IS_PIPE1, IS_PIPE2, IS_PIPE3, IS_BIRD : IN STD_LOGIC;
		STATE : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		COLLISION_DETECTED : OUT STD_LOGIC);
END ENTITY COLLISION;

ARCHITECTURE BEHAV OF COLLISION IS
BEGIN
		COLLISION_DETECTED <= '1' WHEN (IS_BIRD = '1' AND (IS_PIPE1 = '1' OR IS_PIPE2 = '1' OR IS_PIPE3 = '1'  ) AND (STATE = "100" OR STATE = "011")) ELSE 
		'0';

END ARCHITECTURE BEHAV;