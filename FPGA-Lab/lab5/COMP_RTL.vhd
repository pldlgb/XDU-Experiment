library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity COMP_RTL is

port(                               --�˿ڶ���
    CLK: in std_logic;              --ʱ��
	 EXPECTED: in std_logic_vector(3 downto 0);  --�������Ƚϵ���
	 ALU_OUT:  in std_logic_vector(3 downto 0);  --�������Ƚϵ���
	 EN:       in std_logic;                     --ʹ���ź�
	 RESULT : out std_logic                      --����ȽϽ��
	 );

end COMP_RTL;

architecture Behavioral of COMP_RTL is

begin
  process(CLK)
  begin
  if rising_edge(CLK) then       --�ж��Ƿ���ʱ��������
    if(EN='1') then              --�ж�ʹ���ź��Ƿ�Ϊ1
	   if(EXPECTED=ALU_OUT) then   --�ж����������ź��Ƿ����
		  RESULT <= '1';           --��������ֵΪ1
		else
		  RESULT <= '0';           --���������ֵΪ0
		end if;
    end if;
  end if;
end process;

end Behavioral;
