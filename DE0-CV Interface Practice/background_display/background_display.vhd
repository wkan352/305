library IEEE;
use  IEEE.STD_LOGIC_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;


entity back_display is
	port (	pixel_row, pixel_column: in STD_LOGIC_VECTOR(9 DOWNTO 0);
		red, green, blue : out STD_LOGIC);
end entity back_display;

architecture behaviour of back_display is

	Signal is_bar: boolean; -- True when the pixels corresponds to the top bar
	Signal is_sky: boolean; -- True when the pixels corresponds to the sky (Area for the bird to fly in)
	Signal is_ground: boolean; -- True when the pixels corresponds to the ground/grass
	Signal color: std_logic_vector(2 downto 0);

	Constant bar_color : std_logic_vector(2 downto 0) := "000";
	Constant sky_color : std_logic_vector(2 downto 0) := "011";
	Constant ground_color : std_logic_vector(2 downto 0) := "100";

	Constant bar_end_row: std_logic_vector(9 downto 0) := "0000100111";
	Constant sky_end_row: std_logic_vector(9 downto 0) := "0110110111";

begin
	is_bar <= (pixel_row <= bar_end_row);
	is_sky <= ((pixel_row > bar_end_row) and (pixel_row <= sky_end_row));
	is_ground <= (pixel_row > sky_end_row);

	color <= bar_color when is_bar=true else
		 sky_color when is_sky=true else
		 ground_color;

	red <= color(2);
	green <= color(1);
	blue <= color(0);


end architecture behaviour;

