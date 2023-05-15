library IEEE;
use  IEEE.STD_LOGIC_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;


entity back_display is
	port (	pixel_row, pixel_column: in STD_LOGIC_VECTOR(9 DOWNTO 0);
		red, green, blue : OUT std_logic_vector(3 downto 0));
end entity back_display;

architecture behaviour of back_display is

	Signal is_bar: boolean; -- True when the pixels corresponds to the top bar
	Signal is_sky: boolean; -- True when the pixels corresponds to the sky (Area for the bird to fly in)
	Signal is_grass: boolean; -- True when the pixels corresponds to the grass
	Signal color: std_logic_vector(11 downto 0);

	Constant bar_color : std_logic_vector(11 downto 0) := CONV_STD_LOGIC_VECTOR(3758, 12); -- PURPLE
	Constant sky_color : std_logic_vector(11 downto 0) := CONV_STD_LOGIC_VECTOR(2236, 12); -- HEX: 8BC
	Constant grass_color : std_logic_vector(11 downto 0) := CONV_STD_LOGIC_VECTOR(2520, 12); -- HEX: 9D8
	Constant ground_color : std_logic_vector(11 downto 0) := CONV_STD_LOGIC_VECTOR(3545, 12); -- HEX: DD9
	

	Constant bar_end_row: std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(39, 10);
	Constant sky_end_row: std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(439, 10);
	Constant grass_end_row: std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(459, 10);

	

begin
	is_bar <= (pixel_row <= bar_end_row);
	is_sky <= ((pixel_row > bar_end_row) and (pixel_row <= sky_end_row));
	is_grass <= ((pixel_row > sky_end_row) and (pixel_row <= grass_end_row));

	color <= bar_color when is_bar=true else
		 sky_color when is_sky=true else
		 grass_color when is_grass=true else
		 ground_color;

	red <= color(11 downto 8);
	green <= color(7 downto 4);
	blue <= color(3 downto 0);

end architecture behaviour;

