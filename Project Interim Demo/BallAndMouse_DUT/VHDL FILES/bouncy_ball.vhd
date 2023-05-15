LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;


ENTITY bouncy_ball IS
	PORT
		( pb3, vert_sync	: IN std_logic;
          pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
		  red, green, blue 			: OUT std_logic);		
END bouncy_ball;

architecture behavior of bouncy_ball is

SIGNAL ball_on					: std_logic;
SIGNAL size 					: std_logic_vector(9 DOWNTO 0);  
SIGNAL ball_y_pos				: std_logic_vector(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(200,10);
SiGNAL ball_x_pos				: std_logic_vector(10 DOWNTO 0);
type motion is array (0 to 24) of integer;
SIGNAL y_motion			: motion;
SIGNAL ball_y_motion				: std_logic_vector(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(0,10);
BEGIN           

size <= CONV_STD_LOGIC_VECTOR(8,10);
y_motion<= (20,14,10,6,5,4,3,2,1,0,0,0,0,0,0,0,-1,-1,-2,-2,-3,-3,-4,-5,-6);

-- ball_x_pos and ball_y_pos show the (x,y) for the centre of ball
ball_x_pos <= CONV_STD_LOGIC_VECTOR(200,11);


ball_on <= '1' when ( ('0' & ball_x_pos <= '0' & pixel_column + size) and ('0' & pixel_column <= '0' & ball_x_pos + size) 	-- x_pos - size <= pixel_column <= x_pos + size
					and ('0' & ball_y_pos <= pixel_row + size) and ('0' & pixel_row <= ball_y_pos + size) )  else	-- y_pos - size <= pixel_row <= y_pos + size
			'0';


-- Colours for pixel data on video signal
-- Changing the background and ball colour by pushbuttons
Red <=  pb1;
Green <= (not pb2) and (not ball_on);
Blue <=  not ball_on;


Move_Ball: process (vert_sync)  	
variable counter :integer:= 0;
begin
	-- Move ball once every vertical sync
	if(rising_edge(vert_sync)) then
	
		if (pb3='1') then
			counter := 1;
			ball_y_motion <= CONV_STD_LOGIC_VECTOR(0, 10);
			
			-- Bounce off top or bottom of the screen
			
			
			-- Compute next ball Y position
		
		elsif(counter < 25 and counter > 0) then
			if ( (ball_y_pos <= CONV_STD_LOGIC_VECTOR(8,10)) or (ball_y_pos >= (CONV_STD_LOGIC_VECTOR(471,10)))) then
				ball_y_pos <=CONV_STD_LOGIC_VECTOR(200,10);
				ball_y_motion <= CONV_STD_LOGIC_VECTOR(0, 10);
				counter := 0;
				
			else		
					ball_y_motion <= CONV_STD_LOGIC_VECTOR(y_motion(counter), 10);
					counter:= counter + 1;
			end if;
					
		end if;
			
	
		ball_y_pos <= ball_y_pos - ball_y_motion;
					
				
	end if;

end process Move_Ball;


END behavior;

