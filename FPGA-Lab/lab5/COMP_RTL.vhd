library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity COMP_RTL is

port(                               --端口定义
    CLK: in std_logic;              --时钟
	 EXPECTED: in std_logic_vector(3 downto 0);  --两个待比较的数
	 ALU_OUT:  in std_logic_vector(3 downto 0);  --两个待比较的数
	 EN:       in std_logic;                     --使能信号
	 RESULT : out std_logic                      --输出比较结果
	 );

end COMP_RTL;

architecture Behavioral of COMP_RTL is

begin
  process(CLK)
  begin
  if rising_edge(CLK) then       --判断是否是时钟上升沿
    if(EN='1') then              --判断使能信号是否为1
	   if(EXPECTED=ALU_OUT) then   --判断两个输入信号是否相等
		  RESULT <= '1';           --相等输出赋值为1
		else
		  RESULT <= '0';           --不等输出赋值为0
		end if;
    end if;
  end if;
end process;

end Behavioral;
