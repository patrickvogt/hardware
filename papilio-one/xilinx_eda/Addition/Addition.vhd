library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Addition is
	Port( DPAD : in STD_LOGIC_VECTOR(3 downto 0);
			LED : out STD_LOGIC_VECTOR(3 downto 0)
		 );
end Addition;

architecture Behavioral of Addition is
	signal x : STD_LOGIC_VECTOR(1 downto 0);
	signal y : STD_LOGIC_VECTOR(1 downto 0);
	signal carry : STD_LOGIC_VECTOR(1 downto 0);
	signal result : STD_LOGIC_VECTOR(2 downto 0);
begin
 LED <= "0" & result;
 x <= DPAD(1 downto 0);
 y <= DPAD(3 downto 2);
 
 result(0) <= x(0) XOR y(0);
 carry(0) <= x(0) AND y(0);
 result(1) <= x(1) XOR y(1) XOR carry(0);
 carry(1) <= (x(1) AND y(1)) OR (carry(0) AND x(1)) OR (carry(0) AND y(1));
 result(2) <= carry(1);

end Behavioral;

