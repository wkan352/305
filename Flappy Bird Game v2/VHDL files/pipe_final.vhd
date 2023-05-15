LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_SIGNED.all;
USE IEEE.NUMERIC_STD.ALL;

entity pipe is
	generic	(pipe_end : integer := 620; 
		 gap_ypos : integer := 130);
	port ( 	vert_sync : std_logic;
		state: in std_logic_vector(2 downto 0);	
		score : in integer;
		pixel_row, pixel_col : in std_logic_vector(9 downto 0);
		is_pipe : out std_logic);
end entity pipe;

architecture behav of pipe is
	Constant gap_height : integer := 120;
	Constant pipe_width : integer := 60;
	Constant pipe_height : integer := 400;
	Constant pipe_start_y : integer := 40;
	Constant pipe_end_y : integer := 439;
	
	Signal row : integer;
	Signal col : integer;
	
	Signal pipe_speed : integer := 1;
	Signal pipe_end_x : integer := pipe_end;

begin

	-- Conversions
	row <= to_integer(unsigned(pixel_row));
	col <= to_integer(unsigned(pixel_col));

	is_pipe <= '1' when (  ((row >= pipe_start_y and row <= gap_ypos) or 
				(row >= gap_height + gap_ypos and row <= pipe_end_y)) and
				(col <= pipe_end_x and col >= pipe_end_x - pipe_width) and
				state /= "000") else '0';
	
	UPDATE_PIPE_SPEED: PROCESS(SCORE)
	BEGIN
		IF(STATE = "101") THEN
			IF SCORE >= 8 THEN
				PIPE_SPEED <= 2;
			ELSIF SCORE >= 14 THEN
				PIPE_SPEED <= 3;
			ELSE
				PIPE_SPEED <= 4;
			END IF;
		END IF;	

	END PROCESS UPDATE_PIPE_SPEED;
	MOVE_PIPES: PROCESS(VERT_SYNC)
	BEGIN
		IF (RISING_EDGE(VERT_SYNC) AND (STATE = "100" OR STATE = "101")) THEN
			
			IF(pipe_end_x <= 0) THEN
				pipe_end_x <= 699;
			ELSE
				pipe_end_x <= pipe_end_x - pipe_speed;
			END IF;


		END IF;
	END PROCESS MOVE_PIPES;
end architecture behav;