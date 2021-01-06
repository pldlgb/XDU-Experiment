----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:28:28 05/09/2020 
-- Design Name: 
-- Module Name:    CNTRL_FSM - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use WORK.CALC1_PAK.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
entity CNTRL_FSM is
port( DATA_FRAME: in MY_RECORD;
		CLK: in STD_LOGIC;
		RESET: in STD_LOGIC;
		A_IN: out STD_LOGIC_VECTOR(3 downto 0);
		B_IN: out STD_LOGIC_VECTOR(3 downto 0);
		C_IN: out STD_LOGIC;
		OP_CODE: out STD_LOGIC_VECTOR(3 downto 0);
		EXP: out STD_LOGIC_VECTOR(3 downto 0);
		ADDR: out STD_LOGIC_VECTOR(2 downto 0);
		COMP_EN: out STD_LOGIC;
		MEM_EN: out STD_LOGIC;
		ALU_EN: out STD_LOGIC);
end CNTRL_FSM;

architecture RTL of CNTRL_FSM is
	type CNTRL_STATE is(S0_INIT,S1_FETCH,S2_ALU,S3_COMP,S4_DONE);
	signal CURR_STATE,NEXT_STATE : CNTRL_STATE;

	signal ADDR_I,ADDR_Q : STD_LOGIC_VECTOR(2 downto 0);
	begin
	ADDR<=ADDR_Q;

	Sync: process(CLK,RESET)
		begin
			if (RESET ='1')then
				CURR_STATE<=S0_INIT;
				ADDR_Q<=( others =>'0');
			elsif rising_edge ( CLK ) then
				CURR_STATE<=NEXT_STATE;
				ADDR_Q<=ADDR_I;
			end if;
	end process;

	COMB: process(CURR_STATE,DATA_FRAME,ADDR_Q)
		begin
		A_IN<=DATA_FRAME.A_IN;
		B_IN<=DATA_FRAME.B_IN;
		C_IN<=DATA_FRAME.C_IN;
		OP_CODE<=DATA_FRAME.OP_CODE;
		EXP<=DATA_FRAME.EXP_OUT;

		ADDR_I<=ADDR_Q;

		case CURR_STATE is
			when S0_INIT=>
				MEM_EN <='0';
				ALU_EN <='0';
				COMP_EN <='0';
				NEXT_STATE <=S1_FETCH;

			when S1_FETCH=>
				MEM_EN <='1';
				ALU_EN <='0';
				COMP_EN <='0';
				NEXT_STATE <=S2_ALU;

			when S2_ALU=>
				MEM_EN <='0';
				ALU_EN <='1';
				COMP_EN <='0';
				NEXT_STATE <=S3_COMP;

			when S3_COMP=>
				MEM_EN <='0';
				ALU_EN <='0';
				COMP_EN <='1';
				NEXT_STATE <=S4_DONE;

			when S4_DONE=>
				if ADDR_Q>="101"then
					NEXT_STATE <=S4_DONE;
				else
					NEXT_STATE <=S1_FETCH;
					ADDR_I<=ADDR_Q+1;
				end if;
					MEM_EN <='0';
					ALU_EN <='0';
					COMP_EN <='0';

				when others=>
					NEXT_STATE <=S0_INIT;
					MEM_EN <='0';
					ALU_EN <='0';
					COMP_EN <='0';
		end case;
	end process;
end RTL;