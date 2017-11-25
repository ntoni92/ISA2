Library IEEE;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;

Entity dadda_tree_18x5 is
Port(
	in0: IN std_logic_vector (17 DOWNTO 0);
	in1: IN std_logic_vector (17 DOWNTO 0);
	in2: IN std_logic_vector (17 DOWNTO 0);
	in3: IN std_logic_vector (17 DOWNTO 0);
	in4: IN std_logic_vector (17 DOWNTO 0);
	out0: OUT std_logic_vector (17 DOWNTO 0);
	out1: OUT std_logic_vector (17 DOWNTO 0)
);
End Entity;

Architecture structural of dadda_tree_18x5 is

	type level2_type is array (4 DOWNTO 0) of std_logic_vector(17 DOWNTO 0);
	type level1_type is array (2 DOWNTO 0) of std_logic_vector(17 DOWNTO 0);
	type level0_type is array (1 DOWNTO 0) of std_logic_vector(17 DOWNTO 0);
	signal level2: level2_type;
	signal level1: level1_type;
	signal level0: level0_type;
	
	Component fulladd IS
	PORT (    Cin, x, y: IN STD_LOGIC ;
					s, Cout: OUT STD_LOGIC ) ;
	END component;
	
	Component halfadd is
	port(		A,   B:     in  STD_LOGIC;
				SUM, CARRY: out STD_LOGIC);
	end component;
	
	Component compressor_53 is
	port(A,B,C,D,CARRY_IN:     in  STD_LOGIC;
			SUM0, SUM1, CARRY_OUT: out STD_LOGIC);
	end component;

BEGIN
	level2(0) <= in0;
	level2(1) <= in1;
	level2(2) <= in2;
	level2(3) <= in3;
	level2(4) <= in4;

--passing through bits level2 to level1
	level1(1)(6) <= level2 (2)(6);
	level1(2)(6) <= level2 (3)(6);
	level1(2)(7) <= level2 (3)(7);
	level1(1)(14) <= level2 (3)(14);
	level1(1)(15) <= level2 (3)(15);
	row_wires_174_104: for i in 10 to 17 generate
						level1(2)(i) <= level2 (4)(i);
						end generate row_wires_174_104;
	wires_50_02: for i in 0 to 2 generate
						row_wires_50_02: for j in 0 to 5 generate
												level1(i)(j) <= level2 (i)(j);
						
												end generate row_wires_50_02;
						end generate wires_50_02;

--from level2 to level1 compression layer
	level2to1: for i in 6 to 13 generate
					level2to1_ha_low_cond: if i=6 generate
														level2to1_ha: halfadd PORT MAP (	A => level2(1)(i),
																									B => level2(0)(i),
																									SUM => level1(0)(i),
																									CARRY => level1(0)(i+1));
													end generate level2to1_ha_low_cond;
					level2to1_ha_high_cond: if i=12 OR i=13 generate
														level2to1_ha: halfadd PORT MAP (	A => level2(1)(i),
																									B => level2(0)(i),
																									SUM => level1(1)(i),
																									CARRY => level1(0)(i+1));
													end generate level2to1_ha_high_cond;
					level2to1_fa_cond: if i=7 OR i=10 OR i=11 generate
												level2to1_fa: fulladd PORT MAP (	x => level2(2)(i),
																							y => level2(1)(i),
																							Cin => level2(0)(i),
																							s => level1(1)(i),
																							Cout => level1(0)(i+1));
													end generate level2to1_fa_cond;
					level2to1_53_cond: if i=8 OR i=9 generate
												level2to1_53: compressor_53 PORT MAP (	A => level2(4)(i),
																									B => level2(3)(i),
																									C => level2(2)(i),
																									D => level2(1)(i),
																									CARRY_IN => level2(0)(i),
																									SUM0 => level1(1)(i),
																									SUM1 => level1(2)(i),
																									CARRY_OUT => level1(0)(i+1));
													end generate level2to1_53_cond;
					end generate level2to1;
	
--passing through bits level1 to level0
	level0(1)(4) <= level1 (2)(4);
	
	level0(1)(16) <= level1 (2)(16);
	level0(1)(17) <= level1 (2)(17);
	wires_30_01: for i in 0 to 1 generate
						row_wires_30_01: for j in 0 to 3 generate
												level0(i)(j) <= level1 (i)(j);
						
												end generate row_wires_30_01;
						end generate wires_30_01;

--from level1 to level0 compression layer
	level1to0: for i in 4 to 15 generate
					level1to0_ha_low_cond: if i=4 generate
														level1to0_ha: halfadd PORT MAP (	A => level1(1)(i),
																									B => level1(0)(i),
																									SUM => level0(0)(i),
																									CARRY => level0(0)(i+1));
													end generate level1to0_ha_low_cond;
					level1to0_ha_high_cond: if i=15 generate
														level1to0_ha: halfadd PORT MAP (	A => level1(2)(i),
																									B => level1(1)(i),
																									SUM => level0(1)(i),
																									CARRY => level0(0)(i+1));
													end generate level1to0_ha_high_cond;
					level1to0_fa_cond: if i>=5 AND i<=14 generate
												level1to0_fa: fulladd PORT MAP (	x => level1(2)(i),
																							y => level1(1)(i),
																							Cin => level1(0)(i),
																							s => level0(1)(i),
																							Cout => level0(0)(i+1));
													end generate level1to0_fa_cond;
					end generate level1to0;
--level0 to output
	level0(0)(17) <= level0(0)(16);	--MSB extension
	out0 <= level0(0); --operand 1
	out1 <= level0(1); --operand 2

END structural;