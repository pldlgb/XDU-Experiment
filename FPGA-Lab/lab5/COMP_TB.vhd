Library IEEE;
USE ieee.std_logic_1164.ALL;
 

ENTITY COMP_TB IS
END COMP_TB;
 
ARCHITECTURE behavior OF COMP_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT COMP
    PORT(
         CLK : IN  std_logic;
         EXPECTED : IN  std_logic_vector(3 downto 0);
         ALU_OUT : IN  std_logic_vector(3 downto 0);
         EN : IN  std_logic;
         RESULT : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal EXPECTED : std_logic_vector(3 downto 0) := (others => '0');
   signal ALU_OUT : std_logic_vector(3 downto 0) := (others => '0');
   signal EN : std_logic := '0';

 	--Outputs
   signal RESULT : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: COMP PORT MAP (
          CLK => CLK,
          EXPECTED => EXPECTED,
          ALU_OUT => ALU_OUT,
          EN => EN,
          RESULT => RESULT
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
    TB: process
   begin	
      EN <='1';	
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_period*10;
		EXPECTED <=X"A";
		ALU_OUT <=X"A";
		wait for 200 ns;
		ALU_OUT <=X"B";
      -- insert stimulus here 

      wait;
   end process;

END;
