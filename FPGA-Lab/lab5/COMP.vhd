library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity COMP is

port(
    CLK: in std_logic;
	 EXPECTED: in std_logic_vector(3 downto 0);
	 ALU_OUT:  in std_logic_vector(3 downto 0);
	 EN:       in std_logic;
	 RESULT : out std_logic
	 );

end COMP;

architecture Behavioral of COMP is

begin
  process(CLK)
  begin
  if rising_edge(CLK) then
    if(EN='1') then
	   if(EXPECTED=ALU_OUT) then
		  RESULT <= '1';
		else
		  RESULT <= '0';
		end if;
		
		assert(EXPECTED=ALU_OUT)
		  report "Waring simulation mismatch has occurred"
		  severity warning;
    end if;
  end if;
end process;

end Behavioral;