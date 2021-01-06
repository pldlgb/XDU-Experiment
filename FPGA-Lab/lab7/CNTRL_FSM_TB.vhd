library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use WORK.CALC1_PAK.ALL;

entity CNTRL_FSM_TB_VHD is
end CNTRL_FSM_TB_VHD;

architecture TEST of CNTRL_FSM_TB_VHD is
	component CNTRL_FSM
		port(DATA_FRAME: in MY_RECORD;
				CLK: in STD_LOGIC;
				RESET: in STD_LOGIC;
				A_IN: out STD_LOGIC_VECTOR(3 downto 0);
				B_IN: out STD_LOGIC_VECTOR(3 downto 0);
				C_IN: out STD_LOGIC;
				OP_CODE: out STD_LOGIC_VECTOR(3 downto 0);
				EXP: out STD_LOGIC_VECTOR(3 downto 0);
				MEM_EN: out STD_LOGIC;
				ALU_EN: out STD_LOGIC;
				COMP_EN: out STD_LOGIC;
				ADDR: out STD_LOGIC_VECTOR(2 downto 0));
	end component;

	signal DATA_FRAME:MY_RECORD:=("0000","0000","0000",'0',"0000");
	signal CLK: STD_LOGIC:='0';
	signal RESET: STD_LOGIC:='0';
	signal A_IN,B_IN: STD_LOGIC_VECTOR(3 downto 0);
	signal C_IN: STD_LOGIC;
	signal OP_CODE: STD_LOGIC_VECTOR(3 downto 0);
	signal EXP: STD_LOGIC_VECTOR(3 downto 0);
	signal ALU_EN,MEM_EN,COMP_EN: STD_LOGIC;
	signal ADDR: STD_LOGIC_VECTOR(2 downto 0);
begin
	UUT: CNTRL_FSM port map(
		DATA_FRAME =>DATA_FRAME,
		CLK =>CLK,
		RESET =>RESET,
		A_IN =>A_IN,
		B_IN =>B_IN,
		C_IN =>C_IN,
		OP_CODE =>OP_CODE,
		EXP =>EXP,
		ALU_EN =>ALU_EN,
		MEM_EN =>MEM_EN,
		COMP_EN =>COMP_EN,
		ADDR =>ADDR);

	CLK <=not CLK after 20 ns;
	RESET <='1' after 10 ns ,'0' after 25 ns;

TB:process
	begin
		DATA_FRAME<=("1000","0100","0000",'0',"0000");
		wait for 100 ns;
		DATA_FRAME<=("1000","0100","0101",'0',"0000");
		wait for 100 ns;
		DATA_FRAME<=("1000","0100","0100",'0',"0000");
		wait;
	end process;
end test;