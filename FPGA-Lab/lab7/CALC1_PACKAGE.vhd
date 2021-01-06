
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 


library IEEE;
use IEEE.STD_LOGIC_1164.all;

package CALC1_PAK is
   
 type MY_RECORD is record
 A_IN : std_logic_vector ( 3 downto 0 ); 
 B_IN : std_logic_vector ( 3 downto 0 );
 OP_CODE : std_logic_vector ( 3 downto 0 );
 C_IN : std_logic;
 EXP_OUT : std_logic_vector ( 3 downto 0 );
end record MY_RECORD;
  
 
end package CALC1_PAK;
