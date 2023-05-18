LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_SIGNED.all;
USE IEEE.NUMERIC_STD.ALL;

entity pipe is
	port ( 	vert_sync, clk : in std_logic;
		state, gap_ypos_index : in std_logic_vector(2 downto 0);	
		score : in integer;
		
		pixel_row, pixel_col, pipe_end_x: in std_logic_vector(9 downto 0);
		is_pipe_on : out std_logic_vector(1 downto 0);
		is_pipe_passed : out std_logic);
end entity pipe;

architecture behav of pipe is
	Constant gap_height : integer := 150;
	Constant pipe_width : integer := 60;
	Constant pipe_height : integer := 400;
	Constant pipe_start_y : integer := 40;
	Constant pipe_end_y : integer := 439;
	
	Signal row : integer;
	Signal col : integer;
	signal hold_x : integer;
	
	Signal pipe_speed : integer := 1;
	
	type valid_pos is array (0 to 7) of integer;
	signal gap_array : valid_pos := (0,70,90,120,140,185,210,290);

	Signal gap_ypos : integer;
	
	signal is_pipe : std_logic;
	signal rom_address : STD_LOGIC_VECTOR (8 DOWNTO 0);
	signal rom_data : STD_LOGIC_VECTOR (59 DOWNTO 0);
	
	component pipe_rom IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (8 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (59 DOWNTO 0)
	);
END component pipe_rom;

	
begin
	
	pipe_rom_inst : pipe_rom PORT MAP (
		address	 => rom_address,
		clock	 => clk,
		q	 => rom_data
	);

	-- Conversions
	row <= to_integer(unsigned(pixel_row));
	col <= to_integer(unsigned(pixel_col));

	gap_ypos <= gap_array(to_integer(unsigned(gap_ypos_index)));
	
	rom_address <= std_logic_vector(to_unsigned((row - pipe_start_y), rom_address'length)) when is_pipe='1' else "000000000";

	is_pipe <= '1' when (  ((row >= pipe_start_y and row <= gap_ypos) or 
				(row >= gap_height + gap_ypos and row <= pipe_end_y)) and
				(col <= hold_x and col >= hold_x - pipe_width) and
				state /= "000") else '0';
	
	is_pipe_on <= 	"00" when is_pipe = '0' else 
						"01" when is_pipe = '1' and rom_data(col - (hold_x - pipe_width)) = '0' else
						"11";
						
	
	UPDATE_PIPE_SPEED: PROCESS(SCORE)
	BEGIN
		IF(STATE = "100") THEN
			IF SCORE <= 5 THEN
				PIPE_SPEED <= 2;
			ELSIF SCORE <= 20 THEN
				PIPE_SPEED <= 3;
			ELSE
				PIPE_SPEED <= 4;
			END IF;
		ELSE
			PIPE_SPEED <= 2;
		END IF;	

	END PROCESS UPDATE_PIPE_SPEED;
	
	MOVE_PIPES: PROCESS(VERT_SYNC)
	BEGIN
		IF (RISING_EDGE(VERT_SYNC) AND (STATE = "011" OR STATE = "100")) THEN
			
			IF(hold_x <= 0) THEN
				is_pipe_passed <= '1';
					hold_x <= 699;
			ELSE
				hold_x <= hold_x - pipe_speed;
				is_pipe_passed <= '0';
			END IF;
		ELSIF (RISING_EDGE(VERT_SYNC)) THEN
			hold_x <= to_integer(unsigned(pipe_end_x));
		END IF;
	END PROCESS MOVE_PIPES;

end architecture behav;