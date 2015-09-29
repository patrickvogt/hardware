library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Counter2 is
	Port( 
			-- Switches
			Switch : in STD_LOGIC_VECTOR(0 downto 0);
			-- LED array
			LED : out STD_LOGIC_VECTOR(7 downto 0);
			-- clock signal
			clk : in STD_LOGIC
		 );
end Counter2;

architecture Behavioral of Counter2 is
--	-- signal for counter (8 bit)
--	signal counter : STD_LOGIC_VECTOR(7 downto 0);

	-- use numeric_std
	signal counter: unsigned(31 downto 0) := (others => '0');
begin

count: process(clk)
	begin 
		if rising_edge(clk) and Switch(0) = '1' then
			counter <= counter+1;
			LED <= std_logic_vector(resize(shift_right(counter and x"FF000000",24),8));
		end if;
		
	end process;

end Behavioral;