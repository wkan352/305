library IEEE;
use  IEEE.STD_LOGIC_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY COLOR_PIXEL IS
	PORT(	VERT_SYNC, IS_BIRD : IN STD_LOGIC;
			IS_PIPE1, IS_PIPE2, IS_PIPE3 : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		PIXEL_ROW, PIXEL_COL : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		RED, GREEN, BLUE : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END ENTITY COLOR_PIXEL;

ARCHITECTURE BEHAV OF COLOR_PIXEL IS

	Signal is_bar: boolean; -- True when the pixels corresponds to the top bar
	Signal is_sky: boolean; -- True when the pixels corresponds to the sky (Area for the bird to fly in)
	Signal is_grass: boolean; -- True when the pixels corresponds to the grass
	Signal color: std_logic_vector(11 downto 0);

	Constant bar_color : std_logic_vector(11 downto 0) := CONV_STD_LOGIC_VECTOR(2698, 12); -- HEX: A8A
	Constant sky_color : std_logic_vector(11 downto 0) := CONV_STD_LOGIC_VECTOR(2236, 12); -- HEX: 8BC
	Constant grass_color : std_logic_vector(11 downto 0) := CONV_STD_LOGIC_VECTOR(2520, 12); -- HEX: 9D8
	Constant ground_color : std_logic_vector(11 downto 0) := CONV_STD_LOGIC_VECTOR(3545, 12); -- HEX: DD9
	
	Constant bird_color : std_logic_vector(11 downto 0) := CONV_STD_LOGIC_VECTOR(4080, 12); --  yellow
	Constant pipe_color : std_logic_vector(11 downto 0) := CONV_STD_LOGIC_VECTOR(240, 12); --  green
	Constant pipe_color2 : std_logic_vector(11 downto 0) := CONV_STD_LOGIC_VECTOR(4095, 12); -- white FOR NOW

	Constant bar_end_row: std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(39, 10);
	Constant sky_end_row: std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(439, 10);
	Constant grass_end_row: std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(459, 10);


BEGIN
	is_bar <= (pixel_row <= bar_end_row);
	is_sky <= ((pixel_row > bar_end_row) and (pixel_row <= sky_end_row));
	is_grass <= ((pixel_row > sky_end_row) and (pixel_row <= grass_end_row));
		
	color <= 	bird_color when is_bird= '1' else
			pipe_color when (IS_PIPE1 = "01" OR IS_PIPE2 = "01" OR IS_PIPE3 = "01") else
			pipe_color2 when (IS_PIPE1 = "11" OR IS_PIPE2 = "11" OR IS_PIPE3 = "11") else
			bar_color when is_bar=true else
		 	sky_color when is_sky=true else
		 	grass_color when is_grass=true else
		 	ground_color;

	red <= color(11 downto 8);
	green <= color(7 downto 4);
	blue <= color(3 downto 0);

END ARCHITECTURE BEHAV;