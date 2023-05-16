LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY GAME_CONTROLLER IS
	PORT(	SWITCH, PUSH_BTN, LEFT_MOUSE, RIGHT_MOUSE, COLLISION_DETECTED, VERT_SYNC : IN STD_LOGIC;
		LIVES : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		STATE_OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0));
END ENTITY GAME_CONTROLLER;

ARCHITECTURE BEHAV OF GAME_CONTROLLER IS
	TYPE STATE_TYPE IS (S0, S1, S2, S3, S4, S5);
	SIGNAL STATE, NEXT_STATE : STATE_TYPE;
	Signal TEMP_OUTPUT : STD_LOGIC_VECTOR(2 DOWNTO 0);
BEGIN
	STATE_OUT <= TEMP_OUTPUT;

	SYNC_PROC : PROCESS (VERT_SYNC)
	BEGIN
		IF(RISING_EDGE(VERT_SYNC)) THEN
			IF(RIGHT_MOUSE = '1') THEN
				STATE <= S0;
			ELSE
				STATE <= NEXT_STATE;
			END IF;
		END IF;
	END PROCESS SYNC_PROC;
	
	OUTPUT_DECODE : PROCESS (STATE) 
	BEGIN
		CASE(STATE) IS
			WHEN S0 =>
				TEMP_OUTPUT <= "000";
			WHEN S1 =>
				TEMP_OUTPUT <= "001";
			WHEN S2 =>
				TEMP_OUTPUT <= "010";
			WHEN S3 =>
				TEMP_OUTPUT <= "011";
			WHEN S4 =>
				TEMP_OUTPUT <= "100";
			WHEN OTHERS =>
				TEMP_OUTPUT <= "000";
		END CASE;
	END PROCESS;

	NEXT_STATE_DECODE : PROCESS (STATE, LEFT_MOUSE, RIGHT_MOUSE, COLLISION_DETECTED, LIVES, SWITCH, PUSH_BTN)
	BEGIN
		NEXT_STATE <= S0;
		CASE(STATE) IS
			WHEN S0 =>
					if (SWITCH = '0' AND LEFT_MOUSE = '1') then
						next_state <= S1;
					ELSIF (SWITCH = '1' AND LEFT_MOUSE = '1') THEN
						NEXT_STATE <= S2;
					end if;
			WHEN S1 =>
					if (RIGHT_MOUSE = '1') then
						next_state <= S0;
					ELSIF (PUSH_BTN = '1') THEN
						NEXT_STATE <= S3;
					ELSE
						NEXT_STATE <= S1;
					end if;
			WHEN S2 =>
					if (RIGHT_MOUSE = '1') then
						next_state <= S0;
					ELSIF (PUSH_BTN = '1') THEN
						NEXT_STATE <= S4;
					ELSE
						NEXT_STATE <= S2;
					end if;
			WHEN S3 =>
					if (RIGHT_MOUSE = '1') then
						next_state <= S0;
					ELSIF (COLLISION_DETECTED = '1') THEN
						NEXT_STATE <= S1;
					ELSE
						NEXT_STATE <= S3;
					end if;
			WHEN S4 =>
					if (RIGHT_MOUSE = '1' OR (COLLISION_DETECTED = '1' AND LIVES = "00")) then
						next_state <= S0;
					ELSIF (COLLISION_DETECTED = '1' AND LIVES /= "00") THEN
						NEXT_STATE <= S2;
					ELSE
						NEXT_STATE <= S4;
					end if;
			WHEN OTHERS => 
					NEXT_STATE <= S0;


		END CASE;

	END PROCESS NEXT_STATE_DECODE;
	
END ARCHITECTURE BEHAV;