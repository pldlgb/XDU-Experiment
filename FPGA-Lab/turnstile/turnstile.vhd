library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity turnstile is
    Port ( x,clk: in  std_logic;
           z : out  std_logic);
end turnstile;

architecture Behavioral of turnstile is
    type state is (locked,unlocked);
	 signal current:state:=locked;
begin
	process(clk)
	begin
	  if clk='1' and clk'event then
	    case current is
		   when locked=>
			if x='1' then current<=unlocked;else current<=locked;end if;
			when unlocked=>
			if x='0' then current<=locked;else current<=unlocked;end if;
		end case;
	 end if;
	end process;
z<='1' when current=unlocked else '0';

end Behavioral;