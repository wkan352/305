LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY BIRD IS
	PORT (	VERT_SYNC, LEFT_MOUSE : IN STD_LOGIC;
		STATE : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		PIXEL_ROW, PIXEL_COL : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		IS_BIRD : OUT STD_LOGIC);
END ENTITY BIRD;

ARCHITECTURE BEHAV OF BIRD IS

	CONSTANT BIRD_SIZE : INTEGER := 20;
	
	SIGNAL ROW_INT : INTEGER;
	SIGNAL COL_INT : INTEGER;
	SIGNAL BIRD_Y : INTEGER := 245;
	CONSTANT BIRD_X : INTEGER := 55;

BEGIN
	-- CONVERSIONS
	ROW_INT <= TO_INTEGER(UNSIGNED(PIXEL_ROW));
	COL_INT <= TO_INTEGER(UNSIGNED(PIXEL_COL)); 
	

	IS_BIRD <= '1' WHEN ( (ROW_INT >= BIRD_Y) AND (ROW_INT <= BIRD_Y + BIRD_SIZE) AND
			(COL_INT <= BIRD_X) AND (COL_INT >= BIRD_X - BIRD_SIZE) AND STATE/= "000") ELSE '0' ;

MOVE_BIRD: PROCESS(VERT_SYNC)
		VARIABLE CLICKED_ALREADY : STD_LOGIC := '0';
		VARIABLE GRAVITY : INTEGER := 0;
		VARIABLE BIRD_MOTION : INTEGER := 0;
	BEGIN
		IF(RISING_EDGE(VERT_SYNC)) THEN 
			IF(STATE = "011" OR STATE = "100") THEN

				IF(LEFT_MOUSE ='1' AND CLICKED_ALREADY = '0') THEN
					BIRD_MOTION := -12;
					GRAVITY := 1;
				
				ELSE
					BIRD_MOTION := BIRD_MOTION + GRAVITY;
				
				END IF;
			
				-- Remove this portion of the code and added it to the collision component
				IF((BIRD_Y <= (40 + BIRD_MOTION)) OR (BIRD_Y >= (438 - BIRD_SIZE))) THEN
					BIRD_Y <= 239;
					BIRD_MOTION := 0;
					GRAVITY := 0;
				ELSE --------------------------------------------------------
					BIRD_Y <= BIRD_Y + BIRD_MOTION;
				END IF;

				IF LEFT_MOUSE ='1' THEN
					CLICKED_ALREADY :='1';
				
				ELSE
					CLICKED_ALREADY := '0';
				
				END IF;
			END IF;
		END IF;
	END PROCESS MOVE_BIRD;

END ARCHITECTURE BEHAV;

