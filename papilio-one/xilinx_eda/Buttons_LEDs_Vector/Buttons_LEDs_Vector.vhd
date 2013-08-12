library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Buttons_LEDs_Vector is
    Port ( DPAD : in STD_LOGIC_VECTOR(3 downto 0);
           LED  : out STD_LOGIC_VECTOR(3 downto 0) 
			);
end Buttons_LEDs_Vector;

architecture Behavioral of Buttons_LEDs_Vector is

begin
		--LED <= DPAD;
		LED <= "1111";
end Behavioral;

