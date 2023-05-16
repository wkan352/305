LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;
USE IEEE.NUMERIC_STD.ALL;

ENTITY GAME_METRICS IS
	PORT(	VERT_SYNC, IS_PIPE1_PASSED, IS_PIPE2_PASSED, IS_PIPE3_PASSED, COLLISION_DETECTED : IN STD_LOGIC;
		STATE : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		SCORE_OUT : OUT INTEGER;
		LIVES_OUT : OUT STD_LOGIC_VECTOR(1 DOWNTO 0));
END ENTITY GAME_METRICS;

ARCHITECTURE BEHAV OF GAME_METRICS IS
	SIGNAL LIVES : INTEGER := 3;
	SIGNAL SCORE : INTEGER := 0;
BEGIN
	LIVES_OUT <= std_logic_vector(to_unsigned(LIVES, LIVES_OUT'length));
	SCORE_OUT <= SCORE;

	PROCESS(VERT_SYNC)
	BEGIN
		-- Updating Lives
		IF RISING_EDGE(VERT_SYNC) THEN
		IF(STATE = "100") THEN -- State 4
			IF(COLLISION_DETECTED = '1' AND LIVES /= 0) THEN
				LIVES <= LIVES - 1;
			END IF;
		ELSE
			LIVES <= 3;
		END IF;

		-- Update Score
		IF(STATE = "100" OR STATE = "011") THEN
			IF(IS_PIPE1_PASSED = '1' OR IS_PIPE2_PASSED='1' OR IS_PIPE3_PASSED = '1') THEN
				SCORE <= SCORE + 1;
			END IF;
		ELSE 
			SCORE <= 0;
		END IF;
	END IF;	
	END PROCESS;

END ARCHITECTURE BEHAV;