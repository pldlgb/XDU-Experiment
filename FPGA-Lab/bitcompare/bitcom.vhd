----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:26:49 04/03/2020 
-- Design Name: 
-- Module Name:    bitcom - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bitcom is
    Port ( a : in  STD_LOGIC;
           b : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           q : out  STD_LOGIC);
end bitcom;

architecture Behavioral of bitcom is

begin
  bitc: process(a,b,clk)
  begin 
  if rising_edge(clk) then
    if (a=b) then 
	     q <= '1';
	   else 
	     q <= '0';
	 end if;
  end if;
	end process bitc;
end Behavioral;

