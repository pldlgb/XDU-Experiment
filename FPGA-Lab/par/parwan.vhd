
LIBRARY cmos;
USE cmos.basic_utilities.ALL;

PACKAGE alu_operations IS
CONSTANT a_and_b : qit_vector (5 DOWNTO 0) := "000001" ;
CONSTANT b_compl : qit_vector (5 DOWNTO 0) := "000010" ;
CONSTANT ajnput : qit_vector (5 DOWNTO 0) := "000100" ;
CONSTANT a_add_b : qit_vector (5 DOWNTO 0) := "001000" ;
CONSTANT bjnput : qit_vector (5 DOWNTO 0) := "010000" ;
CONSTANT a_sub_b : qit_vector (5 DOWNTO 0) := "100000" ;
END alu_operations;

ENTITY par_control_unit IS
	GENERIC (read_delay, write_delay : TIME := 3 NS);
	 PORT (clk : IN qit;
	-- register control signals:
	load_ac, zero_ac, load_ir, increment_pc, load_page_pc, 
	load_offset_pc, reset_pc, load_page_mar, load_offset_mar, load_sr, cm_carry_sr,
	-- bus connection control signals:
	pc_on_mar_page_bus, ir_on_mar_page_bus, 
	pc_on_mar_offset_bus, d bus_on_mar_offset_bus, 
	pc_otfset_on_dbus, obus_on_dbus, databus_on_dbus, mar_on_adbus, dbus_on_databus,
	-- logic unit function control outputs:
	arith_shift_left, arith_shilt_right,
		alu_and, aiu_not, alu_a, aiu_add, alu_b, alu_sub : OUT ored_qit BUS;
	-- inputs from the data section:
	ir_lines : IN byte; status : IN nibble;
	-- memory control and other external signals:
	read_mem, write_mem : OUT ored_qit BUS; interrupt : IN qit );
END par_control_unit;

ARCHITECTURE dataflow OF par_control_unit IS
SIGNAL s : ored_qit_vector (9 DOWNTO 1) REGISTER := "000000001";
BEGIN
s1: BLOCK (s(1) = '1')
		BEGIN 
		pc_on_mar_page_bus <= GUARDED '1'; 
		pc_on_mar_offset_bus <= GUARDED '1'; 
		load_page_mar <= GUARDED '1';
		load_offset_mar <= GUARDED '1';

		reset_pc <= GUARDED '1' WHEN interrupt = '1' ELSE '0';
		ck: BLOCK ((clk = '0' AND NOT clk'STABLE) AND GUARD) 
		BEGIN
			s(1) <= GUARDED '1' WHEN Interrupt = '1' ELSE '0'; 
			s(2) <= GUARDED '1' WHEN Interrupt /= '1' ELSE '0'; 
		END BLOCK ck;
END BLOCK s1;
s2: BLOCK (s(2) = '1')
		BEGIN 
		mar_on_adbus <= GUARDED '1'; 
		read_mem < GUARDED '1' AFTER read_delay; 
		databus_on_dbus <= GUARDED '1';
		alu_a <= GUARDED '1';
		load_ir <= GUARDED '1';
		increment_pc <= GUARDED '1';
		ck: BLOCK ((clk = '0' AND NOT clk'STABLE) AND GUARD) 
		BEGIN
			s(3) <= GUARDED '1' ; 
	END BLOCK ck;
END BLOCK s2;
s3: BLOCK (s(3) = '1')
		BEGIN
		pc_on_marjage_bus <= GUARDED '1'; 
		pc_on_mar_offset_bus <= GUARDED '1'; 
		load page_mar <= GUARDED '1'; 
		load_offset_mar <= GUARDED '1'; 
		ck: BLOCK ( (clk = '0' AND NOT clk'STABLE) AND GUARD) 
		BEGIN
			s(4) <= GUARDED '1' WHEN ir lines (7 DOWNTO4) /= "1110" ELSE '0';
		END BLOCK ck;
		-- perform single byte instructions
		sb: BLOCK ((ir lines (7 DOWNTO 4) = "1110") AND GUARD)
		BEGIN
			(alu_not, alu_b) <= GUARDED
				qit_vector( "10") WHEN ir_lines (1) = '1' ELSE qit_vector'( "01"); 
			arith_shift_left <=GUARDED
				'1' WHEN ir_lines (3 DOWNTO 0) = "1000" ELSE '0'; 
			aith_shift_right <= GUARDED
				'1' WHEN ir lines (3 DOWNTO 0) = "1001" ELSE '0'; 
			load_sr <= GUARDED
				'1' WHEN ( ir_lines (3) = '1', OR ir lines (1) = '1' ) ELSE '0'; 
			cm_carry_sr <= GUARDED '1', WHEN ir lines (2) = '1' ELSE '0'; 
			load_ac <= GUARDED
				'1' WHEN ( ir_lines (3) ='1' OR ir_lines (1) ='1') ELSE '0'; 
			zero_ac <= GUARDED
				'1' WHEN ( ir lines (3) = '0' AND ir_lines (0) = '1') ELSE '0'; 
			ck: BLOCK ( (clk = '0' AND NOT clk'STABLE) AND GUARD) 
			BEGIN
				s(2) <= GUARDED '1';
			END BLOCK ck;
		END BLOCK sb;
END BLOCK s3,
s4: BLOCK (s(4) ='1')
		BEGIN
			mar_on_adbus <= GUARDED '1'; 
			read_mem <= GUARDED '1' AFTER read_delay; 
			databus_on_dbus <= GUARDED '1'; 
			dbus_on_mar_offset_bus <= GUARDED '1';
			load_offset_mar <= GUARDED '1'; 
			pg: BLOCK ( (ir_lines (7 DOWNTO 6)/= "11") AND GUARD) 
			BEGIN
				ir_on_mar_page_bus <= GUARDED '1'; 
				load_page_mar <= GUARDED '1';
				ck: BLOCK ((clk ='0' AND NOT clk'STABLE) AND GUARD) 
				BEGIN
					s(5) <= GUARDED '1' WHEN ir lines (4) = '1' ELSE '0'; 
					s(6) <= GUARDED '1' WHEN Ir lines (4) = '0' ELSE '0'; 
				END BLOCK ck;
			END BLOCK pg;
			sp: BLOCK ( ir_lines(7 DOWNTO 6)/= "11") AND GUARD)
			BEGIN
			ck: BLOCK ( (clk = '0' AND NOT clk'STABLE) AND GUARD) 
			BEGIN
				s(7) <= GUARDED '1' WHEN ir_lines (5) ='0' ELSE '0';
				s(9) <= GUARDED '1' WHEN ir_lines (5) = '1' ELSE '0'; 
			END BLOCK ck; 
		END BLOCK sp;
		increment_p= GUARDED '1'; 
END BLOCK s4;
s5: BLOCK (s(5) = '1') 
BEGIN 
		mar_on_adbus <= GUARDED '1'; 
		read_mem <= GUARDED '1' AFTER read_delay; 
		databus_on_dbus <= GUARDED '1'; 
		dbus_on_mar_offset_bus <= GUARDED '1'£»
		load_offset_mar <= GUARDED '1';
		ck: BLOCK ((clk = '0' AND NOT clk'STABLE) AND GUARD) 
		BEGIN
			s(6) <= GUARDED '1';
		END BLOCK ck;
END BLOCK s5;
s6:BLOCK (S(6)='1')
BEGIN
		jm : BLOCK ((ir_llnes (7 DOWNTO 5) ="100" ) AND GUARD 
	BEGIN
			load_page_pc <= GUARDED '1'; 
			Ioad_otfset_pc <t GUARDED '1';
			ck: BLOCK ((clk = '0' AND NOT clk'STABLE) AND GUARD) 
			BEGIN
				s(2) <= GUARDED '1';
			END BLOCK ck;
		END BLOCK jm;
		st: BLOCK ( (ir_Iines (7 DOWNTO 5) = "101") AND GUARD) 
		BEGIN
			mar_on_adbus <= GUARDED '1';
			alu_b = GUARDED '1'; 
			obus_on_dbus c= GUARDED '1'; 
			dbus_on_databus = GUARDED '1'; 
			write_mem <= GUARDED '1' AFTER write_delay;
			ck: BLOCK ( (clk = '0' AND NOT clk'STABLE) AND GUARD) 
			BEGIN
				s(1) <= GUARDED '1';
			END BLOCK ck;
	END BLOCK st;
		rd:BLOCK ( (Ir_lines (7) = '0') AND GUARD)
		BEGIN
			mar_on_adbus <= GUARDED '1';
			read_mem <= GUARDED '1' AFTER read_delay; 
			databus_on_dbus <= GUARDED '1';
			alu_a <= GUARDED '1' WHEN ir_lines (6 DOWNTO 5) ="00" ELSE '0'; 
			alu_and <= GUARDED '1' WHEN ir_lines (6 DOWNTO 5) = "01" ELSE '0';
			alu_add <= GUARDED '1' WHEN ir_lines (6 DOWNTO 5) = "10" ELSE '0'; 
			alu_sub <= GUARDED '1' WHEN ir_lines (6 DOWNTO 5) = "11" ELSE '0'; 
			load_sr <= GUARDED '1';
			load_ac <= GUARDED '1';
			ck: BLOCK ((clk = '0' AND NOT clk'STABLE) AND GUARD) 
			BEGIN
				s(1) <= GUARDED '1';
			END BLOCK ck;
	END BLOCK rd; 
END BLOCK s6;
s7: BLOCK (s(7) = '1') 
BEGIN
		mar_on_adbus <= GUARDED '1';
		pc_offset_on_dbus <= GUARDED '1'; 
		dbus_on_databus <= GUARDED '1';
		write_mem <= GUARDED '1' AFTER write_ delay;
		Ioad_offsetjc <= GUARDED '1';
		ck: BLOCK ((clk = '0' AND NOT clk'STABLE) AND GUARD) 
		BEGIN
			s(8) <= GUARDED '1';
		END BLOCK ck;
END BLOCK s7;
s8: BLOCK (s(8) = '1') 
BEGIN
	increment_pc <= GUARDED '1';
	ck: BLOCK ((clk ='0' AND NOT clk'STABLE) AND GUARD)
		BEGIN
			s(1) <= GUARDED '1';
	END BLOCK ck;
END BLOCK s8;
s9: BLOCK (s(9) ='1') 
BEGIN
	Ioad_offset_pc <= GUARDED
		'1' WHEN (status AND ir_Ilnes (3 DOWNTO 0)) /= "0000" ELSE '0';
	ck: BLOCK ( (clk = '0' AND NOT clk'STABLE) AND GUARD)
	BEGIN
			s(1) <= GUARDED '1';
		END BLOCK ck;
END BLOCK s9;
s (9 DOWNTO 1) <= GUARDED "000000000";
	END BLOCK ck;
END dataflow;