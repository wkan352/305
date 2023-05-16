LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY FSM_PLACEHOLDER IS
	PORT(	VERT_SYNC, LEFT_MOUSE : IN STD_LOGIC;
		PIPE1_END, PIPE1_GAP, PIPE2_END, PIPE2_GAP, PIPE3_END, PIPE3_GAP,
		BIRD_X, BIRD_Y : OUT INTEGER);

END ENTITY FSM_PLACEHOLDER;

ARCHITECTURE BEHAV OF FSM_PLACEHOLDER IS
	SIGNAL TEMP_BIRD_Y: INTEGER := 245;
	SIGNAL TEMP_PIPE1_END: INTEGER := 200;
	SIGNAL TEMP_PIPE2_END: INTEGER := 400;
	SIGNAL TEMP_PIPE3_END : INTEGER := 620;

	CONSTANT BIRD_SIZE : INTEGER := 20;
BEGIN
	PIPE1_GAP <= 165;
	PIPE2_GAP <= 300;
	PIPE3_GAP <= 120;
	BIRD_X <= 55; 
	BIRD_Y <= TEMP_BIRD_Y;
	PIPE1_END <= TEMP_PIPE1_END;
	PIPE2_END <= TEMP_PIPE2_END;
	PIPE3_END <= TEMP_PIPE3_END;
	

	MOVE_PIPES: PROCESS(VERT_SYNC)
	BEGIN
	IF (RISING_EDGE(VERT_SYNC)) THEN
		-- MOVE THE FIRST PIPE
		IF(TEMP_PIPE1_END <= 0) THEN
			TEMP_PIPE1_END <= 699;
		ELSE
			TEMP_PIPE1_END <= TEMP_PIPE1_END - 2;
		END IF;

		-- MOVE THE SECOND PIPE
		IF(TEMP_PIPE2_END <= 0) THEN
			TEMP_PIPE2_END <= 699;
		ELSE
			TEMP_PIPE2_END <= TEMP_PIPE2_END - 2;
		END IF;

		-- MOVE THE THIRD PIPE
		IF(TEMP_PIPE3_END <= 0) THEN
			TEMP_PIPE3_END <= 699;
		ELSE
			TEMP_PIPE3_END <= TEMP_PIPE3_END - 2;
		END IF;

	END IF;
	END PROCESS MOVE_PIPES;

	
	MOVE_BIRD: PROCESS(VERT_SYNC)
		VARIABLE CLICKED_ALREADY : STD_LOGIC := '0';
		VARIABLE GRAVITY : INTEGER := 0;
		VARIABLE BIRD_MOTION : INTEGER := 0;
	BEGIN
		IF(RISING_EDGE(VERT_SYNC)) THEN
			IF(LEFT_MOUSE ='1' AND CLICKED_ALREADY = '0') THEN
				BIRD_MOTION := -12;
				GRAVITY := 1;
				
			ELSE
				BIRD_MOTION := BIRD_MOTION + GRAVITY;
				
			END IF;
			
			IF((TEMP_BIRD_Y <= (40 + BIRD_MOTION)) OR (TEMP_BIRD_Y >= (438 - BIRD_SIZE))) THEN
				TEMP_BIRD_Y <= 239;
				BIRD_MOTION := 0;
				GRAVITY := 0;
			ELSE
				TEMP_BIRD_Y <= TEMP_BIRD_Y + BIRD_MOTION;
			END IF;

			IF LEFT_MOUSE ='1' THEN
				CLICKED_ALREADY :='1';
				
			ELSE
				CLICKED_ALREADY := '0';
				
			END IF;
		END IF;
	END PROCESS MOVE_BIRD;

END ARCHITECTURE BEHAV;