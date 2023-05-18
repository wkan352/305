LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_SIGNED.all;
USE IEEE.NUMERIC_STD.ALL;

ENTITY MENU IS
	PORT(	STATE : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		CLK : IN STD_LOGIC;
		RED_IN, GREEN_IN, BLUE_IN : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		PIXEL_ROW, PIXEL_COL : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		RED_OUT, GREEN_OUT, BLUE_OUT : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END ENTITY MENU;

ARCHITECTURE BEHAV OF MENU IS
	SIGNAL IS_MENU_ON : STD_LOGIC;
	SIGNAL ROW, COL : INTEGER;

	SIGNAL ROM_ADDRESS : STD_LOGIC_VECTOR (8 DOWNTO 0);
	SIGNAL ROM_DATA : STD_LOGIC_VECTOR (299 DOWNTO 0);
	
	COMPONENT welcome_menu_rom IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (8 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (299 DOWNTO 0)
	);
	END COMPONENT welcome_menu_rom;
	

BEGIN
	-- CONVERSIONS
	ROW <= TO_INTEGER(UNSIGNED(PIXEL_ROW));
	COL <= TO_INTEGER(UNSIGNED(PIXEL_COL));


	IS_MENU_ON <= '1' WHEN ( ( ROW >= 89) AND (ROW <= 389) AND (COL >= 169) AND (COL <= 469) AND STATE = "000") ELSE '0';
	
	welcome_menu_rom_inst : welcome_menu_rom PORT MAP (
		address	 => ROM_ADDRESS,
		clock	 => CLK,
		q	 => ROM_DATA
	);
	
	ROM_ADDRESS <= STD_LOGIC_VECTOR(TO_UNSIGNED((ROW - 89), ROM_ADDRESS'LENGTH )) WHEN IS_MENU_ON = '1' ELSE "000000000";
	
	RED_OUT <= 	RED_IN WHEN IS_MENU_ON = '0' ELSE
			"1111" WHEN ROM_DATA(COL-169)='0' ELSE
			 "1001";
	GREEN_OUT <= 	GREEN_IN WHEN IS_MENU_ON = '0' ELSE
			"1111" WHEN ROM_DATA(COL-169)='0' ELSE
			 "1101";
	BLUE_OUT <= 	BLUE_IN WHEN IS_MENU_ON = '0' ELSE
			"1111" WHEN ROM_DATA(COL-169)='0' ELSE
			 "1111";

END ARCHITECTURE BEHAV;