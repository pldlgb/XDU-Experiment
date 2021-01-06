----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:47:27 03/27/2020 
-- Design Name: 
-- Module Name:    MEM - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.all
use IEEE.STD_LOGIC_UNSIGNED.all
use WORK CALC1_PAK.all

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MEM is
	port(CLK,EN:IN STD_LOGIC;
		  ADDR: in STD_LOGIC_VECTOR(2 downto 0):="000";
		  DATA_FRAME:out MY_RECORD);
end entity MEM;

architecture Behavioral of MEM is
	type ROM_ARRAY is array(0 to 5)of MY_RECORD;
	
	constant MY_ROM: ROM_ARRAY:=
     ( 0 => ( A_IN => "1000", B_IN => "0010", OP_CODE => "0001", C_IN => '0', EXP_OUT => "1010" ),
      1 => ( A_IN => "0100", B_IN => "0010", OP_CODE => "0001", C_IN => '0', EXP_OUT => "0110" ),
		2 => ( A_IN => "0010", B_IN => "0010", OP_CODE => "0001", C_IN => '0', EXP_OUT => "0100" ),
		3 => ( A_IN => "0001", B_IN => "0010", OP_CODE => "0001", C_IN => '0', EXP_OUT => "0011" ), -- induce error
		4 => ( A_IN => "0011", B_IN => "0010", OP_CODE => "0001", C_IN => '0', EXP_OUT => "0101" ),
		5 => ( A_IN => "0111", B_IN => "0010", OP_CODE => "0001", C_IN => '0', EXP_OUT => "1001" ));	

begin
process(CLK)
	begin 
		if rising_edge(CLK) then 
			if(EN ='1') then 
				DATA_FRAME<=MY_ROM(conv_integer(ADDR));
			end if£»
		end if;
end process;
end RTL;

