library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Addition is
	Port( 
			-- DPAD Buttons
			DPAD : in STD_LOGIC_VECTOR(3 downto 0);
			-- LED array
			LED : out STD_LOGIC_VECTOR(3 downto 0)
		 );
end Addition;

architecture Behavioral of Addition is
	-- signal for input number x (2 bit)
	signal x : STD_LOGIC_VECTOR(1 downto 0);
	-- signal for input number y (2 bit)
	signal y : STD_LOGIC_VECTOR(1 downto 0);
	-- signal for carries of addition (2 bit but shifted one bit to the left)
	signal carry : STD_LOGIC_VECTOR(1 downto 0);
	-- result of the addition (3 bit)
	signal result : STD_LOGIC_VECTOR(2 downto 0);
begin
 -- assign rsult to the 4 LED array (and disable LED for the MSB)
 -- & is used for concatenation in VHDL
 LED <= "0" & result;
 -- input number x (2 bit) will be two buttons 
 x <= DPAD(1 downto 0);
 -- inout number y (2 bit) will be the other two buttons
 y <= DPAD(3 downto 2);
 
 -- calculation logic
 
 -- bit 0
 result(0) <= x(0) XOR y(0);
 -- carry 0
 carry(0) <= x(0) AND y(0);
 -- bit 1
 result(1) <= x(1) XOR y(1) XOR carry(0);
 -- carry 1
 carry(1) <= (x(1) AND y(1)) OR (carry(0) AND x(1)) OR (carry(0) AND y(1));
 -- bit 2
 result(2) <= carry(1);

end Behavioral;

