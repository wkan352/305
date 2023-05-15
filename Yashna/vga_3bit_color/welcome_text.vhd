LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

LIBRARY altera_mf;
USE altera_mf.all;

entity text_welcome is 
	port (pixel_row, pixel_col : in std_logic_vector(9 downto 0);
		clock : in std_logic;
		is_pixel_text : out std_logic);
end entity text_welcome;

architecture behav of text_welcome is
	-- Creating arrarys to access the specfied character's addresses
	type address is array (0 to 6) of std_logic_vector(5 downto 0);
	Signal welcome_address : address;
	type font is array (0 to 7) of std_logic_vector(2 downto 0);
	Signal letters_font : font;
	
	-- Signal used to check if pixel is in the text area
	Signal text_on : std_logic;
	
	-- Will be connected to the altsyncram component
	Signal rom_address : std_logic_vector(8 downto 0);
	Signal rom_data : std_logic_vector(7 downto 0);

	COMPONENT altsyncram
	GENERIC (
		address_aclr_a			: STRING;
		clock_enable_input_a	: STRING;
		clock_enable_output_a	: STRING;
		init_file				: STRING;
		intended_device_family	: STRING;
		lpm_hint				: STRING;
		lpm_type				: STRING;
		numwords_a				: NATURAL;
		operation_mode			: STRING;
		outdata_aclr_a			: STRING;
		outdata_reg_a			: STRING;
		widthad_a				: NATURAL;
		width_a					: NATURAL;
		width_byteena_a			: NATURAL
	);
	PORT (
		clock0		: IN STD_LOGIC ;
		address_a	: IN STD_LOGIC_VECTOR (8 DOWNTO 0);
		q_a			: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
	END COMPONENT;

begin

	altsyncram_component : altsyncram
	GENERIC MAP (
		address_aclr_a => "NONE",
		clock_enable_input_a => "BYPASS",
		clock_enable_output_a => "BYPASS",
		init_file => "tcgrom.mif",
		intended_device_family => "Cyclone III",
		lpm_hint => "ENABLE_RUNTIME_MOD=NO",
		lpm_type => "altsyncram",
		numwords_a => 512,
		operation_mode => "ROM",
		outdata_aclr_a => "NONE",
		outdata_reg_a => "UNREGISTERED",
		widthad_a => 9,
		width_a => 8,
		width_byteena_a => 1
	)
	PORT MAP (
		clock0 => clock,
		address_a => rom_address,
		q_a => rom_data
	);


	welcome_address(0) <= CONV_STD_LOGIC_VECTOR(23, 6); 	-- Address for W
	welcome_address(1) <= CONV_STD_LOGIC_VECTOR(5, 6); 		-- E
	welcome_address(2) <= CONV_STD_LOGIC_VECTOR(12, 6); 	-- L
	welcome_address(3) <= CONV_STD_LOGIC_VECTOR(3, 6); 		-- C
	welcome_address(4) <= CONV_STD_LOGIC_VECTOR(15, 6);		-- O
	welcome_address(5) <= CONV_STD_LOGIC_VECTOR(13, 6); 	-- M
	welcome_address(6) <= CONV_STD_LOGIC_VECTOR(5, 6); 		-- E

	letters_font(0) <= CONV_STD_LOGIC_VECTOR(0, 3);
	letters_font(1) <= CONV_STD_LOGIC_VECTOR(1, 3);
	letters_font(2) <= CONV_STD_LOGIC_VECTOR(2, 3);
	letters_font(3) <= CONV_STD_LOGIC_VECTOR(3, 3);
	letters_font(4) <= CONV_STD_LOGIC_VECTOR(4, 3);
	letters_font(5) <= CONV_STD_LOGIC_VECTOR(5, 3);
	letters_font(6) <= CONV_STD_LOGIC_VECTOR(6, 3);
	letters_font(7) <= CONV_STD_LOGIC_VECTOR(7, 3);

	process
			-- Counters
		variable col_counter : integer := 0;
		variable row_counter : integer := 0;
		variable address_counter : integer :=0;

	begin
		-- Before doing anything
		wait until ((pixel_col = 0) and (pixel_col <= CONV_STD_LOGIC_VECTOR(55, 10))
					and (pixel_row = 0) and (pixel_row <= CONV_STD_LOGIC_VECTOR(55, 10)));
		rom_address <= welcome_address(address_counter) & letters_font(row_counter);
		text_on <= rom_data(CONV_INTEGER(NOT letters_font(col_counter)));

		if (col_counter = 7) then	
			col_counter := 0;
		else
			col_counter := col_counter + 1;
		end if;

		if (address_counter = 6) then	
			address_counter := 0;
		else
			address_counter := address_counter + 1;
		end if;
		
		if (pixel_row = CONV_STD_LOGIC_VECTOR(55, 10)) then
			row_counter := row_counter + 1;
		end if;

	end process;	
	is_pixel_text <= text_on;
end architecture behav;