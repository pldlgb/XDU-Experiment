LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY ALU_TB_vhd IS
END ALU_TB_vhd;

ARCHITECTURE test OF ALU_TB_vhd IS 
	COMPONENT alu
	PORT(	CLK : in std_logic ;
	      OP_CODE : IN std_logic_vector(3 downto 0);
		    A : IN std_logic_vector(3 downto 0);
		    B : IN std_logic_vector(3 downto 0);
		    C_IN : IN std_logic;
			 EN : IN std_logic;          
		    Y : OUT std_logic_vector(3 downto 0)
		 );
	END COMPONENT;

 
	SIGNAL OP_CODE_SIG :  std_logic_vector(3 downto 0):= (others => '0');
	SIGNAL A_SIG :  std_logic_vector(3 downto 0):= "0111" ;
	SIGNAL B_SIG :  std_logic_vector(3 downto 0):= "0011" ;
	SIGNAL C_IN_SIG :  std_logic := '0';
	SIGNAL EN_SIG : std_logic := '1';
	SIGNAL Y_SIG :  std_logic_vector(3 downto 0);
	SIGNAL CLK :  std_logic := '0' ;
	
	SIGNAL OP_CODE_CI_SIG : std_logic_vector ( 4 downto 0 ) := (others => '0') ;
begin      
	  OP_CODE_SIG <= OP_CODE_CI_SIG(4 downto 1);
	  C_IN_SIG <= OP_CODE_CI_SIG(0);
		
	uut: alu PORT MAP(
 
		OP_CODE => OP_CODE_SIG,
		A => A_SIG,
		B => B_SIG,
		C_IN => C_IN_SIG,
		Y => Y_SIG,
		EN => EN_SIG,
		CLK => CLK  );
  
  clk <= not clk after 10 ns; 

  process
  begin 
  OP_CODE_CI_SIG <= "00000";   wait for 100 ns;
  OP_CODE_CI_SIG <= "00001";   wait for 100 ns;
  OP_CODE_CI_SIG <= "00010";   wait for 100 ns;
  OP_CODE_CI_SIG <= "00011";   wait for 100 ns;
  OP_CODE_CI_SIG <= "00100";   wait for 100 ns;
  OP_CODE_CI_SIG <= "00101";   wait for 100 ns;
  OP_CODE_CI_SIG <= "00110";   wait for 100 ns;
  OP_CODE_CI_SIG <= "00111";   wait for 100 ns;
  OP_CODE_CI_SIG <= "01000";   wait for 100 ns;
  OP_CODE_CI_SIG <= "01010";   wait for 100 ns;
  OP_CODE_CI_SIG <= "01100";   wait for 100 ns;
  OP_CODE_CI_SIG <= "01110";   wait for 100 ns;
  OP_CODE_CI_SIG <= "10000";   wait;
end process; 

END architecture test;

