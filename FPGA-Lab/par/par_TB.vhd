-- TestBench Template 
LIBRARY cmos;
USE cmos.basic_utilities.ALL;
  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY testbench IS
  END testbench;

  ARCHITECTURE input_output OF parwan tester IS
COMPONENT parwan PORT(clk: IN qit; interrupt : IN qit; 
read_mem, write_mem : OUT qit; 
databus : INOUT wired_byte BUS; adbus : OUT twelve);
	SIGNAL clock, interrupt, read, write : qit;
	SIGNAL data: wired_byte := "ZZZZZZZZ";
	SIGNAL address : twelve;
	TYPE byte_memory IS ARRAY (INTEGER RANGE <>) OF byte; 
BEGIN
	int : interrupt <= '1', '0' AFTER 4500 NS;
	clk: clock <= NOT clock AFTER 1 US WHEN NOW<= 140 US ELSE clock; 
	cpu : parwan PORT MAP (clock, interrupt, read, write, data, address);
	mem : PROCESS
		VARIABLE memory : byte_memory (0 TO 63):=
			("00000000", "00011000", "10100000", "00011001",		
			"00100000","00011010","01000000","00011011",
			"11100010","11101001","01100000","00011100",
			"00010000","00011101","11000000","00100100",
			"11101000","11100000","10000000","00100000",
			"00000000","00000000","00000000","00000000",
			"01011100","00000000","01110000","00010010",
			"00001100","00011111","00000000","01011010",
			"10000000","00010010","00000000","00000000",
			"00000000","11100010","10010000","00100100",
			OTHERS => (OTHERS =>'0')); 
	VARIABLE ia: INTEGER; 
BEGIN
	WAIT ON read, write; 
	qit2int (address, ia); 
		IF read ='1' THEN
			IF ia >=64 THEN
				data <= "ZZZZZZZZ";
			ELSE
				data <= wired_byte ( memory (ia));
			END IF;
			WAIT UNTIL read ='0'; 
			data <= "ZZZZZZZZ";
			ELSIF write = '1' THEN 
			IF ia < 64 THEN
				memory (ia) := byte (data);
			END IF;
			WAIT UNTIL write = '0';
		END IF;
	END PROC ES,S mem
END input_outpt; 

