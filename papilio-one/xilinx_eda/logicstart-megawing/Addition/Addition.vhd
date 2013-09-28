library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Addition is
	Port( 
			-- Switches
			Switch : in STD_LOGIC_VECTOR(7 downto 0);
			-- LED array
			LED : out STD_LOGIC_VECTOR(7 downto 0)
		 );
end Addition;

architecture Behavioral of Addition is
--	-- signal for input number x (4 bit)
--	signal x : STD_LOGIC_VECTOR(3 downto 0);
--	-- signal for input number y (4 bit)
--	signal y : STD_LOGIC_VECTOR(3 downto 0);
--	-- signal for carries of addition (4 bit but shifted one bit to the left)
--	signal carry : STD_LOGIC_VECTOR(3 downto 0);
--	-- result of the addition (5 bit)
--	signal result : STD_LOGIC_VECTOR(4 downto 0);

	-- use numeric_std
	signal x: unsigned(3 downto 0);
	signal y: unsigned(3 downto 0);
	signal result: unsigned(4 downto 0);
begin
---- assign result to the 8 LED array (and disable the three LEDs for the MSB)
-- -- & is used for concatenation in VHDL
-- LED <= "000" & result;
-- -- input number x (4 bit) will be two buttons 
-- x <= Switch(3 downto 0);
-- -- inout number y (4 bit) will be the other two buttons
-- y <= Switch(3 downto 2);

 -- assign result to the 8 LED array (and disable the three LEDs for the MSB)
 -- & is used for concatenation in VHDL
 LED <= "000" & std_logic_vector(result);
 -- input number x (2 bit) will be two buttons 
 x <= unsigned(Switch(3 downto 0));
 -- inout number y (2 bit) will be the other two buttons
 y <= unsigned(Switch(7 downto 4));
 
 -- calculation logic
 
 result <= ("0" & x) + ("0" & y);
 
-- -- bit 0
-- result(0) <= x(0) XOR y(0);
-- -- carry 0
-- carry(0) <= x(0) AND y(0);
-- -- bit 1
-- result(1) <= x(1) XOR y(1) XOR carry(0);
-- -- carry 1
-- carry(1) <= (x(1) AND y(1)) OR (carry(0) AND x(1)) OR (carry(0) AND y(1));
-- -- bit 2
-- result(2) <= carry(1);

end Behavioral;

