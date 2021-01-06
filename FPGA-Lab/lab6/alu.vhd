library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU is
   port ( CLK			: in std_logic ;
	       OP_CODE 	: in std_logic_vector ( 3 downto 0 ) ;
   		 A,B       	: in std_logic_vector ( 3 downto 0 ) ;
	 	    C_IN 		: in std_logic ;
			 EN		   : in std_logic ; 
		    Y 		   : out std_logic_vector (3 downto 0) );		
end entity ALU;

architecture RTL of ALU is
 
    signal OP_CODE_CI : std_logic_vector ( 4 downto 0 );
    

begin	 
	 OP_CODE_CI <= OP_CODE & C_IN ;
	
	
	process ( CLK ) begin
	  if rising_edge ( CLK ) then  
	if (EN = '1') then  
   case OP_CODE_CI is
	   when "00000" => Y <= A;
	   when "00001" => Y <= A + 1 ; 
	   when "00010" => Y <= A + B ; 
	   when "00011" => Y <= A + B + 1; 
	   when "00100" => Y <= A + not B ; 
	   when "00101" => Y <= A + not B + 1; 
	   when "00110" => Y <= A - 1 ; 
	   when "00111" => Y <= A ;
		when "01000" => Y <= A and B ;
		when "01010" => Y <= A or B ;
		when "01100" => Y <= A xor B ;
		when "01110" => Y <= not A ;
		when "10000" => Y <= (others => '0') ;
		when others  => Y <= (others => 'X' );
	end case;
	end if;
  end if ;
 
end process;
 
end architecture RTL;
	   	   


 

