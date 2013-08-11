library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Buttons_LEDs is
    Port 
	 (      
	        DPAD_LEFT  : in  STD_LOGIC;
           DPAD_UP    : in  STD_LOGIC;
           DPAD_RIGHT : in  STD_LOGIC;
           DPAD_DOWN  : in  STD_LOGIC;
           LED_1      : out  STD_LOGIC;
           LED_2      : out  STD_LOGIC;
           LED_3      : out  STD_LOGIC;
           LED_4      : out  STD_LOGIC
   );
end Buttons_LEDs;

architecture Behavioral of Buttons_LEDs is

begin
	-- assign Buttons and LEDs
	LED_1 <= DPAD_LEFT;
	LED_2 <= DPAD_UP;
	LED_3 <= DPAD_RIGHT;
	LED_4 <= DPAD_DOWN;
end Behavioral;

