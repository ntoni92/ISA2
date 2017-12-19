Library IEEE;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;

Entity dadda_tree_18x6_NoExt is
Port(
	in0: IN std_logic_vector (17 DOWNTO 0);
	in1: IN std_logic_vector (17 DOWNTO 0);
	in2: IN std_logic_vector (17 DOWNTO 0);
	in3: IN std_logic_vector (17 DOWNTO 0);
	in4: IN std_logic_vector (17 DOWNTO 0);
	in5: IN std_logic_vector (17 DOWNTO 0);
	out0: OUT std_logic_vector (17 DOWNTO 0);
	out1: OUT std_logic_vector (17 DOWNTO 0)
);
End Entity;

Architecture Roorda of dadda_tree_18x6_NoExt is

	type level3_type is array (5 DOWNTO 0) of std_logic_vector(17 DOWNTO 0);
	type level2_type is array (3 DOWNTO 0) of std_logic_vector(17 DOWNTO 0);
	type level1_type is array (2 DOWNTO 0) of std_logic_vector(17 DOWNTO 0);
	type level0_type is array (1 DOWNTO 0) of std_logic_vector(18 DOWNTO 0);
	signal level3: level3_type;
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
	level3(0) <= in0;
	level3(1) <= in1;
	level3(2) <= in2;
	level3(3) <= in3;
	level3(4) <= in4;
	level3(5) <= in5;
------------------------------------------------------------------------------------------------
--passing through bits level3 to level2
	level2(0)(0) <= level3 (0)(0);
	level2(0)(1) <= level3 (0)(1);
	level2(0)(2) <= level3 (0)(2);
	level2(0)(3) <= level3 (0)(3);
	level2(0)(4) <= level3 (0)(4);
	level2(0)(5) <= level3 (0)(5);
	level2(0)(15) <= level3 (3)(15);
	level2(0)(16) <= level3 (3)(16);
	level2(0)(17) <= level3 (4)(17);
	
	level2(1)(0) <= level3 (5)(0);
	level2(1)(2) <= level3 (1)(2);
	level2(1)(3) <= level3 (1)(3);
	level2(1)(4) <= level3 (1)(4);
	level2(1)(5) <= level3 (1)(5);
	level2(1)(6) <= level3 (2)(6);
	level2(1)(14) <= level3 (2)(14);
	level2(1)(15) <= level3 (4)(15);
	level2(1)(16) <= level3 (4)(16);
	level2(1)(17) <= level3 (5)(17);
	
	level2(2)(2) <= level3 (5)(2);
	level2(2)(4) <= level3 (2)(4);
	level2(2)(5) <= level3 (2)(5);
	level2(2)(6) <= level3 (3)(6);
	level2(2)(7) <= level3 (2)(7);
	level2(2)(8) <= level3 (5)(8);
	level2(2)(13) <= level3 (4)(13);
	level2(2)(14) <= level3 (3)(14);
	level2(2)(15) <= level3 (5)(15);
	
	level2(3)(4) <= level3 (5)(4);
	level2(3)(6) <= level3 (5)(6);
	level2(3)(7) <= level3 (3)(7);
	level2(3)(9) <= level3 (5)(9);
	level2(3)(12) <= level3 (4)(12);
	level2(3)(13) <= level3 (5)(13);
	level2(3)(14) <= level3 (4)(14);
	
	
--from level3 to level2 compression layer
	level3to2: for i in 6 to 13 generate
					level3to2_ha_cond: if i=6 generate
														level3to2_ha: halfadd PORT MAP (	A => level3(1)(i),
																							B => level3(0)(i),
																							SUM => level2(0)(i),
																							CARRY => level2(0)(i+1));
													end generate level3to2_ha_cond;
					level3to2_ha_low_cond: if i=7 generate
														level3to2_ha: halfadd PORT MAP (	A => level3(1)(i),
																							B => level3(0)(i),
																							SUM => level2(1)(i),
																							CARRY => level2(0)(i+1));
													end generate level3to2_ha_low_cond;
					level3to2_ha_up_cond: if i=13 generate
														level3to2_ha: halfadd PORT MAP (	A => level3(3)(i),
																							B => level3(2)(i),
																							SUM => level2(1)(i),
																							CARRY => level2(0)(i+1));
													end generate level3to2_ha_up_cond;
					level3to2_fa_cond: if i=12 generate
												level3to2_fa: fulladd PORT MAP (	x => level3(3)(i),
																					y => level3(2)(i),
																					Cin => level3(1)(i),
																					s => level2(2)(i),
																					Cout => level2(0)(i+1));
													end generate level3to2_fa_cond;
					level3to2_53_cond_first: if i=8 generate
												level3to2_53: compressor_53 PORT MAP (	A => level3(4)(i),
																						B => level3(3)(i),
																						C => level3(2)(i),
																						D => level3(1)(i),
																						CARRY_IN => level3(0)(i),
																						SUM0 => level2(1)(i),
																						SUM1 => level2(0)(i+1),
																						CARRY_OUT => level2(1)(i+1));
													end generate level3to2_53_cond_first;
					level3to2_53_cond_mid: if i>=9 and i<=10 generate
												level3to2_53: compressor_53 PORT MAP (	A => level3(4)(i),
																						B => level3(3)(i),
																						C => level3(2)(i),
																						D => level3(1)(i),
																						CARRY_IN => level3(0)(i),
																						SUM0 => level2(2)(i),
																						SUM1 => level2(0)(i+1),
																						CARRY_OUT => level2(1)(i+1));
													end generate level3to2_53_cond_mid;
					level3to2_53_cond: if i=11 generate
												level3to2_53: compressor_53 PORT MAP (	A => level3(5)(i),
																						B => level3(4)(i),
																						C => level3(3)(i),
																						D => level3(2)(i),
																						CARRY_IN => level3(1)(i),
																						SUM0 => level2(2)(i),
																						SUM1 => level2(0)(i+1),
																						CARRY_OUT => level2(1)(i+1));
													end generate level3to2_53_cond;
					end generate level3to2;	
	
------------------------------------------------------------------------------------------------
--passing through bits level2 to level1
	level1(0)(0) <= level2 (0)(0);
	level1(0)(1) <= level2 (0)(1);
	level1(0)(2) <= level2 (0)(2);
	level1(0)(3) <= level2 (0)(3);
	level1(0)(17) <= level2 (0)(17);
	
	level1(1)(0) <= level2 (1)(0);
	level1(1)(2) <= level2 (1)(2);
	level1(1)(3) <= level2 (1)(3);
	level1(1)(4) <= level2 (2)(4);
	level1(1)(16) <= level2 (0)(16);
	level1(1)(17) <= level2 (1)(17);
	
	level1(2)(2) <= level2 (2)(2);
	level1(2)(4) <= level2 (3)(4);
	level1(2)(5) <= level2 (2)(5);
	level1(2)(6) <= level2 (3)(6);
	level1(2)(7) <= level2 (3)(7);
	level1(2)(8) <= level2 (2)(8);
	level1(2)(9) <= level2 (3)(9);
	level1(2)(10) <= level2 (2)(10);
	level1(2)(11) <= level2 (2)(11);
	level1(2)(12) <= level2 (3)(12);
	level1(2)(13) <= level2 (3)(13);
	level1(2)(14) <= level2 (3)(14);
	level1(2)(15) <= level2 (2)(15);
	level1(2)(16) <= level2 (1)(16);
	

--from level2 to level1 compression layer
	level2to1: for i in 4 to 15 generate
					level2to1_ha_cond: if i=4 generate
														level2to1_ha: halfadd PORT MAP (	A => level2(1)(i),
																							B => level2(0)(i),
																							SUM => level1(0)(i),
																							CARRY => level1(0)(i+1));
													end generate level2to1_ha_cond;
					level2to1_ha_mid_cond: if i=5 or i=8 or i=10 or i=11 or i=15 generate
														level2to1_ha: halfadd PORT MAP (	A => level2(1)(i),
																							B => level2(0)(i),
																							SUM => level1(1)(i),
																							CARRY => level1(0)(i+1));
													end generate level2to1_ha_mid_cond;
					level2to1_fa_cond: if i=6 or i=7 or i=9 or i=12 or i=13 or i=14 generate
												level2to1_fa: fulladd PORT MAP (	x => level2(2)(i),
																					y => level2(1)(i),
																					Cin => level2(0)(i),
																					s => level1(1)(i),
																					Cout => level1(0)(i+1));
													end generate level2to1_fa_cond;
					end generate level2to1;
	
------------------------------------------------------------------------------------------------
--passing through bits level1 to level0
	level0(0)(0) <= level1 (0)(0);
	level0(0)(1) <= level1 (0)(1);
	
	level0(1)(0) <= level1 (1)(0);
	level0(1)(2) <= level1 (2)(2);
	

--from level1 to level0 compression layer
	level1to0: for i in 2 to 17 generate
					level1to0_ha_low_cond: if i=2 generate
														level1to0_ha: halfadd PORT MAP (	A => level1(1)(i),
																							B => level1(0)(i),
																							SUM => level0(0)(i),
																							CARRY => level0(0)(i+1));
														end generate level1to0_ha_low_cond;
					level1to0_ha_mid_cond: if i=3 or i=17 generate
														level1to0_ha: halfadd PORT MAP (	A => level1(1)(i),
																							B => level1(0)(i),
																							SUM => level0(1)(i),
																							CARRY => level0(0)(i+1));
													end generate level1to0_ha_mid_cond;
					level1to0_fa_second_cond: if i>=4 and i<=16 generate
												level1to0_fa: fulladd PORT MAP (	x => level1(2)(i),
																					y => level1(1)(i),
																					Cin => level1(0)(i),
																					s => level0(1)(i),
																					Cout => level0(0)(i+1));
													end generate level1to0_fa_second_cond;
					end generate level1to0;
					
--level0 to output
	level0(1)(1)<='0';
	out0 <= level0(0)(17 DOWNTO 0); --operand 1
	out1 <= level0(1)(17 DOWNTO 0); --operand 2
	
	
END Roorda;

Architecture approx of dadda_tree_18x6_NoExt is

	type level3_type is array (5 DOWNTO 0) of std_logic_vector(17 DOWNTO 0);
	type level2_type is array (3 DOWNTO 0) of std_logic_vector(17 DOWNTO 0);
	type level1_type is array (2 DOWNTO 0) of std_logic_vector(17 DOWNTO 0);
	type level0_type is array (1 DOWNTO 0) of std_logic_vector(18 DOWNTO 0);
	signal level3: level3_type;
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
	
	Component compressor_53_approx is
	port(A,B,C,D,CARRY_IN:     in  STD_LOGIC;
			SUM0, SUM1, CARRY_OUT: out STD_LOGIC);
	end component;

BEGIN
	level3(0) <= in0;
	level3(1) <= in1;
	level3(2) <= in2;
	level3(3) <= in3;
	level3(4) <= in4;
	level3(5) <= in5;
------------------------------------------------------------------------------------------------
--passing through bits level3 to level2
	level2(0)(0) <= level3 (0)(0);
	level2(0)(1) <= level3 (0)(1);
	level2(0)(2) <= level3 (0)(2);
	level2(0)(3) <= level3 (0)(3);
	level2(0)(4) <= level3 (0)(4);
	level2(0)(5) <= level3 (0)(5);
	level2(0)(15) <= level3 (3)(15);
	level2(0)(16) <= level3 (3)(16);
	level2(0)(17) <= level3 (4)(17);
	
	level2(1)(0) <= level3 (5)(0);
	level2(1)(2) <= level3 (1)(2);
	level2(1)(3) <= level3 (1)(3);
	level2(1)(4) <= level3 (1)(4);
	level2(1)(5) <= level3 (1)(5);
	level2(1)(6) <= level3 (2)(6);
	level2(1)(14) <= level3 (2)(14);
	level2(1)(15) <= level3 (4)(15);
	level2(1)(16) <= level3 (4)(16);
	level2(1)(17) <= level3 (5)(17);
	
	level2(2)(2) <= level3 (5)(2);
	level2(2)(4) <= level3 (2)(4);
	level2(2)(5) <= level3 (2)(5);
	level2(2)(6) <= level3 (3)(6);
	level2(2)(7) <= level3 (2)(7);
	level2(2)(8) <= level3 (5)(8);
	level2(2)(13) <= level3 (4)(13);
	level2(2)(14) <= level3 (3)(14);
	level2(2)(15) <= level3 (5)(15);
	
	level2(3)(4) <= level3 (5)(4);
	level2(3)(6) <= level3 (5)(6);
	level2(3)(7) <= level3 (3)(7);
	level2(3)(9) <= level3 (5)(9);
	level2(3)(12) <= level3 (4)(12);
	level2(3)(13) <= level3 (5)(13);
	level2(3)(14) <= level3 (4)(14);
	
	
--from level3 to level2 compression layer
	level3to2: for i in 6 to 13 generate
					level3to2_ha_cond: if i=6 generate
														level3to2_ha: halfadd PORT MAP (	A => level3(1)(i),
																							B => level3(0)(i),
																							SUM => level2(0)(i),
																							CARRY => level2(0)(i+1));
													end generate level3to2_ha_cond;
					level3to2_ha_low_cond: if i=7 generate
														level3to2_ha: halfadd PORT MAP (	A => level3(1)(i),
																							B => level3(0)(i),
																							SUM => level2(1)(i),
																							CARRY => level2(0)(i+1));
													end generate level3to2_ha_low_cond;
					level3to2_ha_up_cond: if i=13 generate
														level3to2_ha: halfadd PORT MAP (	A => level3(3)(i),
																							B => level3(2)(i),
																							SUM => level2(1)(i),
																							CARRY => level2(0)(i+1));
													end generate level3to2_ha_up_cond;
					level3to2_fa_cond: if i=12 generate
												level3to2_fa: fulladd PORT MAP (	x => level3(3)(i),
																					y => level3(2)(i),
																					Cin => level3(1)(i),
																					s => level2(2)(i),
																					Cout => level2(0)(i+1));
													end generate level3to2_fa_cond;
					level3to2_53_cond_first: if i=8 generate
												level3to2_53: compressor_53_approx PORT MAP (	A => level3(4)(i),
																						B => level3(3)(i),
																						C => level3(2)(i),
																						D => level3(1)(i),
																						CARRY_IN => level3(0)(i),
																						SUM0 => level2(1)(i),
																						SUM1 => level2(0)(i+1),
																						CARRY_OUT => level2(1)(i+1));
													end generate level3to2_53_cond_first;
					level3to2_53_cond_mid: if i>=9 and i<=10 generate
												level3to2_53: compressor_53_approx PORT MAP (	A => level3(4)(i),
																						B => level3(3)(i),
																						C => level3(2)(i),
																						D => level3(1)(i),
																						CARRY_IN => level3(0)(i),
																						SUM0 => level2(2)(i),
																						SUM1 => level2(0)(i+1),
																						CARRY_OUT => level2(1)(i+1));
													end generate level3to2_53_cond_mid;
					level3to2_53_cond: if i=11 generate
												level3to2_53: compressor_53_approx PORT MAP (	A => level3(5)(i),
																						B => level3(4)(i),
																						C => level3(3)(i),
																						D => level3(2)(i),
																						CARRY_IN => level3(1)(i),
																						SUM0 => level2(2)(i),
																						SUM1 => level2(0)(i+1),
																						CARRY_OUT => level2(1)(i+1));
													end generate level3to2_53_cond;
					end generate level3to2;	
	
------------------------------------------------------------------------------------------------
--passing through bits level2 to level1
	level1(0)(0) <= level2 (0)(0);
	level1(0)(1) <= level2 (0)(1);
	level1(0)(2) <= level2 (0)(2);
	level1(0)(3) <= level2 (0)(3);
	level1(0)(17) <= level2 (0)(17);
	
	level1(1)(0) <= level2 (1)(0);
	level1(1)(2) <= level2 (1)(2);
	level1(1)(3) <= level2 (1)(3);
	level1(1)(4) <= level2 (2)(4);
	level1(1)(16) <= level2 (0)(16);
	level1(1)(17) <= level2 (1)(17);
	
	level1(2)(2) <= level2 (2)(2);
	level1(2)(4) <= level2 (3)(4);
	level1(2)(5) <= level2 (2)(5);
	level1(2)(6) <= level2 (3)(6);
	level1(2)(7) <= level2 (3)(7);
	level1(2)(8) <= level2 (2)(8);
	level1(2)(9) <= level2 (3)(9);
	level1(2)(10) <= level2 (2)(10);
	level1(2)(11) <= level2 (2)(11);
	level1(2)(12) <= level2 (3)(12);
	level1(2)(13) <= level2 (3)(13);
	level1(2)(14) <= level2 (3)(14);
	level1(2)(15) <= level2 (2)(15);
	level1(2)(16) <= level2 (1)(16);
	

--from level2 to level1 compression layer
	level2to1: for i in 4 to 15 generate
					level2to1_ha_cond: if i=4 generate
														level2to1_ha: halfadd PORT MAP (	A => level2(1)(i),
																							B => level2(0)(i),
																							SUM => level1(0)(i),
																							CARRY => level1(0)(i+1));
													end generate level2to1_ha_cond;
					level2to1_ha_mid_cond: if i=5 or i=8 or i=10 or i=11 or i=15 generate
														level2to1_ha: halfadd PORT MAP (	A => level2(1)(i),
																							B => level2(0)(i),
																							SUM => level1(1)(i),
																							CARRY => level1(0)(i+1));
													end generate level2to1_ha_mid_cond;
					level2to1_fa_cond: if i=6 or i=7 or i=9 or i=12 or i=13 or i=14 generate
												level2to1_fa: fulladd PORT MAP (	x => level2(2)(i),
																					y => level2(1)(i),
																					Cin => level2(0)(i),
																					s => level1(1)(i),
																					Cout => level1(0)(i+1));
													end generate level2to1_fa_cond;
					end generate level2to1;
	
------------------------------------------------------------------------------------------------
--passing through bits level1 to level0
	level0(0)(0) <= level1 (0)(0);
	level0(0)(1) <= level1 (0)(1);
	
	level0(1)(0) <= level1 (1)(0);
	level0(1)(2) <= level1 (2)(2);
	

--from level1 to level0 compression layer
	level1to0: for i in 2 to 17 generate
					level1to0_ha_low_cond: if i=2 generate
														level1to0_ha: halfadd PORT MAP (	A => level1(1)(i),
																							B => level1(0)(i),
																							SUM => level0(0)(i),
																							CARRY => level0(0)(i+1));
														end generate level1to0_ha_low_cond;
					level1to0_ha_mid_cond: if i=3 or i=17 generate
														level1to0_ha: halfadd PORT MAP (	A => level1(1)(i),
																							B => level1(0)(i),
																							SUM => level0(1)(i),
																							CARRY => level0(0)(i+1));
													end generate level1to0_ha_mid_cond;
					level1to0_fa_second_cond: if i>=4 and i<=16 generate
												level1to0_fa: fulladd PORT MAP (	x => level1(2)(i),
																					y => level1(1)(i),
																					Cin => level1(0)(i),
																					s => level0(1)(i),
																					Cout => level0(0)(i+1));
													end generate level1to0_fa_second_cond;
					end generate level1to0;
					
--level0 to output
	level0(1)(1)<='0';
	out0 <= level0(0)(17 DOWNTO 0); --operand 1
	out1 <= level0(1)(17 DOWNTO 0); --operand 2
	
	
END approx;

Architecture approxCut of dadda_tree_18x6_NoExt is

	type level3_type is array (5 DOWNTO 0) of std_logic_vector(17 DOWNTO 0);
	type level2_type is array (3 DOWNTO 0) of std_logic_vector(17 DOWNTO 0);
	type level1_type is array (2 DOWNTO 0) of std_logic_vector(17 DOWNTO 0);
	type level0_type is array (1 DOWNTO 0) of std_logic_vector(18 DOWNTO 0);
	signal level3: level3_type;
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
	
	Component compressor_53_approx is
	port(A,B,C,D,CARRY_IN:     in  STD_LOGIC;
			SUM0, SUM1, CARRY_OUT: out STD_LOGIC);
	end component;

BEGIN
	level3(0) <= in0;
	level3(1) <= in1;
	level3(2) <= in2;
	level3(3) <= in3;
	level3(4) <= in4;
	level3(5) <= in5;
------------------------------------------------------------------------------------------------
--passing through bits level3 to level2
	
	level2(0)(7) <= level3 (0)(7);
	level2(0)(9) <= level3 (5)(9);
	level2(0)(15) <= level3 (3)(15);
	level2(0)(16) <= level3 (3)(16);
	level2(0)(17) <= level3 (4)(17);
	
	level2(1)(7) <= level3 (1)(7);
	level2(1)(8) <= level3 (3)(8);
	level2(1)(14) <= level3 (2)(14);
	level2(1)(15) <= level3 (4)(15);
	level2(1)(16) <= level3 (4)(16);
	level2(1)(17) <= level3 (5)(17);
	
	level2(2)(7) <= level3 (2)(7);
	level2(2)(8) <= level3 (4)(8);
	level2(2)(13) <= level3 (4)(13);
	level2(2)(14) <= level3 (3)(14);
	level2(2)(15) <= level3 (5)(15);

	level2(3)(7) <= level3 (3)(7);
	level2(3)(8) <= level3 (5)(8);
	level2(3)(9) <= level3 (5)(9);
	level2(3)(12) <= level3 (4)(12);
	level2(3)(13) <= level3 (5)(13);
	level2(3)(14) <= level3 (4)(14);
	
	
--from level3 to level2 compression layer
	level3to2: for i in 8 to 13 generate
					level3to2_ha_up_cond: if i=13 generate
														level3to2_ha: halfadd PORT MAP (	A => level3(3)(i),
																							B => level3(2)(i),
																							SUM => level2(1)(i),
																							CARRY => level2(0)(i+1));
													end generate level3to2_ha_up_cond;
					level3to2_fa_cond: if i=12 generate
												level3to2_fa: fulladd PORT MAP (	x => level3(3)(i),
																					y => level3(2)(i),
																					Cin => level3(1)(i),
																					s => level2(2)(i),
																					Cout => level2(0)(i+1));
													end generate level3to2_fa_cond;
					level3to2_fa_first_cond: if i=8 generate
												level3to2_fa: fulladd PORT MAP (	x => level3(3)(i),
																					y => level3(2)(i),
																					Cin => level3(1)(i),
																					s => level2(0)(i),
																					Cout => level2(1)(i+1));
													end generate level3to2_fa_first_cond;
					level3to2_53_cond_mid: if i>=9 and i<=10 generate
												level3to2_53: compressor_53_approx PORT MAP (	A => level3(4)(i),
																						B => level3(3)(i),
																						C => level3(2)(i),
																						D => level3(1)(i),
																						CARRY_IN => level3(0)(i),
																						SUM0 => level2(2)(i),
																						SUM1 => level2(0)(i+1),
																						CARRY_OUT => level2(1)(i+1));
													end generate level3to2_53_cond_mid;
					level3to2_53_cond: if i=11 generate
												level3to2_53: compressor_53_approx PORT MAP (	A => level3(5)(i),
																						B => level3(4)(i),
																						C => level3(3)(i),
																						D => level3(2)(i),
																						CARRY_IN => level3(1)(i),
																						SUM0 => level2(2)(i),
																						SUM1 => level2(0)(i+1),
																						CARRY_OUT => level2(1)(i+1));
													end generate level3to2_53_cond;
					end generate level3to2;	
	
------------------------------------------------------------------------------------------------
--passing through bits level2 to level1

	level1(0)(17) <= level2 (0)(17);
	
	level1(1)(7) <= level2 (2)(7);
	level1(1)(16) <= level2 (0)(16);
	level1(1)(17) <= level2 (1)(17);
	
	level1(2)(7) <= level2 (3)(7);
	level1(2)(8) <= level2 (2)(8);
	level1(2)(9) <= level2 (3)(9);
	level1(2)(10) <= level2 (2)(10);
	level1(2)(11) <= level2 (2)(11);
	level1(2)(12) <= level2 (3)(12);
	level1(2)(13) <= level2 (3)(13);
	level1(2)(14) <= level2 (3)(14);
	level1(2)(15) <= level2 (2)(15);
	level1(2)(16) <= level2 (1)(16);
	

--from level2 to level1 compression layer
	level2to1: for i in 7 to 15 generate
					level2to1_ha_first_cond: if i=7 generate
														level2to1_ha: halfadd PORT MAP (	A => level2(1)(i),
																							B => level2(0)(i),
																							SUM => level1(0)(i),
																							CARRY => level1(0)(i+1));
													end generate level2to1_ha_first_cond;
	
					level2to1_ha_mid_cond: if i=9 or i=10 or i=11 or i=15 generate
														level2to1_ha: halfadd PORT MAP (	A => level2(1)(i),
																							B => level2(0)(i),
																							SUM => level1(1)(i),
																							CARRY => level1(0)(i+1));
													end generate level2to1_ha_mid_cond;
					level2to1_fa_cond: if i=8 or i=12 or i=13 or i=14 generate
												level2to1_fa: fulladd PORT MAP (	x => level2(2)(i),
																					y => level2(1)(i),
																					Cin => level2(0)(i),
																					s => level1(1)(i),
																					Cout => level1(0)(i+1));
													end generate level2to1_fa_cond;
					end generate level2to1;
	
------------------------------------------------------------------------------------------------
--passing through bits level1 to level0
	level0(1)(7) <= level1 (2)(7);
	

--from level1 to level0 compression layer
	level1to0: for i in 7 to 17 generate
					level1to0_ha_mid_cond: if i=17 generate
														level1to0_ha: halfadd PORT MAP (	A => level1(1)(i),
																							B => level1(0)(i),
																							SUM => level0(1)(i),
																							CARRY => level0(0)(i+1));
													end generate level1to0_ha_mid_cond;
					level1to0_fa_second_cond: if i>=8 and i<=16 generate
												level1to0_fa: fulladd PORT MAP (	x => level1(2)(i),
																					y => level1(1)(i),
																					Cin => level1(0)(i),
																					s => level0(1)(i),
																					Cout => level0(0)(i+1));
													end generate level1to0_fa_second_cond;
					level1to0_ha_first_cond: if i=7 generate
														level1to0_ha: halfadd PORT MAP (	A => level1(1)(i),
																							B => level1(0)(i),
																							SUM => level0(0)(i),
																							CARRY => level0(0)(i+1));
													end generate level1to0_ha_first_cond;
					end generate level1to0;
					
--level0 to output
	out0(17 DOWNTO 7) <= level0(0)(17 DOWNTO 7); --operand 1
	out1(17 DOWNTO 7) <= level0(1)(17 DOWNTO 7); --operand 2
	out0(6 DOWNTO 0) <= (others=>'0');
	out1(6 DOWNTO 0) <= (others=>'0');
	
	
	
END approxCut;

Architecture final of dadda_tree_18x6_NoExt is

	type level2_type is array (5 DOWNTO 0) of std_logic_vector(17 DOWNTO 0);
	type level1_type is array (3 DOWNTO 0) of std_logic_vector(17 DOWNTO 0);
	type level0_type is array (1 DOWNTO 0) of std_logic_vector(18 DOWNTO 0);
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
	
	Component compressor_42_approx is
	port(A,B,C,D:     in  STD_LOGIC;
			SUM0, SUM1: out STD_LOGIC);
	end Component;
	
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
	level2(5) <= in5;
------------------------------------------------------------------------------------------------
--passing through bits level2 to level1
	
	level1(0)(0) <= level2 (0)(0);
	level1(0)(1) <= level2 (0)(1);
	level1(0)(2) <= level2 (0)(2);
	level1(0)(3) <= level2 (0)(3);
	level1(0)(4) <= level2 (0)(4);
	level1(0)(5) <= level2 (0)(5);
	level1(0)(6) <= level2 (2)(6);
	level1(0)(17) <= level2 (4)(17);
	
	level1(1)(0) <= level2 (5)(0);
	level1(1)(2) <= level2 (1)(2);
	level1(1)(3) <= level2 (1)(3);
	level1(1)(4) <= level2 (1)(4);
	level1(1)(5) <= level2 (1)(5);
	level1(1)(16) <= level2 (3)(16);
	level1(1)(17) <= level2 (5)(17);
	
	level1(2)(2) <= level2 (5)(2);
	level1(2)(4) <= level2 (2)(4);
	level1(2)(5) <= level2 (2)(5);
	level1(2)(6) <= level2 (3)(6);
	level1(2)(7) <= level2 (2)(7);
	level1(2)(8) <= level2 (4)(8);
	level1(2)(9) <= level2 (5)(9);
	level1(2)(15) <= level2 (5)(15);
	level1(2)(16) <= level2 (4)(16);

	level1(3)(4) <= level2 (5)(4);
	level1(3)(6) <= level2 (5)(6);
	level1(3)(7) <= level2 (3)(7);
	level1(3)(8) <= level2 (5)(8);
	
	
	
--from level2 to level1 compression layer
	level2to1: for i in 6 to 15 generate
					level2to1_ha_cond_first: if i=6 or i=7 generate
												level2to1_ha: halfadd PORT MAP (	A => level2(1)(i),
																					B => level2(0)(i),
																					SUM => level1(1)(i),
																					CARRY => level1(0)(i+1));
													end generate level2to1_ha_cond_first;
					level2to1_42approx_cond: if i=8 generate
									level2to1_42approx: compressor_42_approx PORT MAP (	A => level2(3)(i),
																								B => level2(2)(i),
																								C => level2(1)(i),
																								D => level2(0)(i),
																								SUM0 => level1(1)(i),
																								SUM1 => level1(0)(i+1));
													end generate level2to1_42approx_cond;
					level2to1_53_cond_first: if i=9 or i=10 generate
												level2to1_53: compressor_53 PORT MAP (	A => level2(4)(i),
																						B => level2(3)(i),
																						C => level2(2)(i),
																						D => level2(1)(i),
																						CARRY_IN => level2(0)(i),
																						SUM0 => level1(1)(i),
																						SUM1 => level1(0)(i+1),
																						CARRY_OUT => level1(2)(i+1));
													end generate level2to1_53_cond_first;
					level2to1_53_cond_mid: if i=11 or i=12 generate
												level2to1_53: compressor_53 PORT MAP (	A => level2(5)(i),
																						B => level2(4)(i),
																						C => level2(3)(i),
																						D => level2(2)(i),
																						CARRY_IN => level2(1)(i),
																						SUM0 => level1(1)(i),
																						SUM1 => level1(0)(i+1),
																						CARRY_OUT => level1(2)(i+1));
													end generate level2to1_53_cond_mid;
					level2to1_53_cond_last: if i=13 generate
												level2to1_53: compressor_53 PORT MAP (	A => '0',
																						B => level2(5)(i),
																						C => level2(4)(i),
																						D => level2(3)(i),
																						CARRY_IN => level2(2)(i),
																						SUM0 => level1(1)(i),
																						SUM1 => level1(0)(i+1),
																						CARRY_OUT => level1(2)(i+1));
													end generate level2to1_53_cond_last;
					level2to1_fa_cond: if i=14 generate
												level2to1_ha: fulladd PORT MAP (	x => level2(4)(i),
																					y => level2(3)(i),
																					Cin => level2(2)(i),
																					s => level1(1)(i),
																					Cout => level1(0)(i+1));
													end generate level2to1_fa_cond;
					level2to1_ha_cond_last: if i=15 generate
												level2to1_ha: halfadd PORT MAP (	A => level2(4)(i),
																					B => level2(3)(i),
																					SUM => level1(1)(i),
																					CARRY => level1(0)(i+1));
													end generate level2to1_ha_cond_last;
					end generate level2to1;	
	

------------------------------------------------------------------------------------------------
--passing through bits level1 to level0
	level0(0)(0) <= level1(0)(0);
	level0(0)(1) <= level1(0)(1);
	level0(0)(2) <= level1(2)(2);
	
	level0(1)(0) <= level1(1)(0);
	
--additive 0s for next layer
	level0(1)(1) <= '0';

--from level1 to level0 compression layer
	level1to0: for i in 2 to 17 generate
					level1to0_ha_cond_first: if i=2 or i=3 generate
												level1to0_ha: halfadd PORT MAP (	A => level1(1)(i),
																							B => level1(0)(i),
																							SUM => level0(1)(i),
																							CARRY => level0(0)(i+1));
													end generate level1to0_ha_cond_first;
					level1to0_42approx_cond: if i>=4 and i<=8 generate
										level1to0_42approx: compressor_42_approx PORT MAP (	A => level1(3)(i),
																								B => level1(2)(i),
																								C => level1(1)(i),
																								D => level1(0)(i),
																								SUM0 => level0(1)(i),
																								SUM1 => level0(0)(i+1));
													end generate level1to0_42approx_cond;
					level1to0_42_cond: if i>=9 and i<=16 generate
										level1to0_fa: fulladd PORT MAP (	x => level1(2)(i),
																					y => level1(1)(i),
																					Cin => level1(0)(i),
																					s => level0(1)(i),
																					Cout => level0(0)(i+1));
													end generate level1to0_42_cond;										
					level1to0_ha_cond_last: if i=17 generate
														level1to0_ha: halfadd PORT MAP (	A => level1(1)(i),
																							B => level1(0)(i),
																							SUM => level0(1)(i),
																							CARRY => level0(0)(i+1));
													end generate level1to0_ha_cond_last;		
					end generate level1to0;			
--level0 to output
	out0(17 DOWNTO 0) <= level0(0)(17 DOWNTO 0); --operand 1
	out1(17 DOWNTO 0) <= level0(1)(17 DOWNTO 0); --operand 2
END final;

Architecture final_cut of dadda_tree_18x6_NoExt is

	type level2_type is array (5 DOWNTO 0) of std_logic_vector(17 DOWNTO 0);
	type level1_type is array (3 DOWNTO 0) of std_logic_vector(17 DOWNTO 0);
	type level0_type is array (1 DOWNTO 0) of std_logic_vector(18 DOWNTO 0);
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
	
	Component compressor_42_approx is
	port(A,B,C,D:     in  STD_LOGIC;
			SUM0, SUM1: out STD_LOGIC);
	end Component;
	
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
	level2(5) <= in5;
------------------------------------------------------------------------------------------------
--passing through bits level2 to level1

	level1(0)(6) <= level2 (2)(6);
	level1(0)(17) <= level2 (4)(17);

	level1(1)(16) <= level2 (3)(16);
	level1(1)(17) <= level2 (5)(17);

	level1(2)(6) <= level2 (3)(6);
	level1(2)(7) <= level2 (2)(7);
	level1(2)(8) <= level2 (4)(8);
	level1(2)(9) <= level2 (5)(9);
	level1(2)(15) <= level2 (5)(15);
	level1(2)(16) <= level2 (4)(16);

	level1(3)(6) <= level2 (5)(6);
	level1(3)(7) <= level2 (3)(7);
	level1(3)(8) <= level2 (5)(8);
	
	
	
--from level2 to level1 compression layer
	level2to1: for i in 6 to 15 generate
					level2to1_ha_cond_first: if i=6 or i=7 generate
												level2to1_ha: halfadd PORT MAP (	A => level2(1)(i),
																					B => level2(0)(i),
																					SUM => level1(1)(i),
																					CARRY => level1(0)(i+1));
													end generate level2to1_ha_cond_first;
					level2to1_42approx_cond: if i=8 generate
									level2to1_42approx: compressor_42_approx PORT MAP (	A => level2(3)(i),
																								B => level2(2)(i),
																								C => level2(1)(i),
																								D => level2(0)(i),
																								SUM0 => level1(1)(i),
																								SUM1 => level1(0)(i+1));
													end generate level2to1_42approx_cond;
					level2to1_53_cond_first: if i=9 or i=10 generate
												level2to1_53: compressor_53 PORT MAP (	A => level2(4)(i),
																						B => level2(3)(i),
																						C => level2(2)(i),
																						D => level2(1)(i),
																						CARRY_IN => level2(0)(i),
																						SUM0 => level1(1)(i),
																						SUM1 => level1(0)(i+1),
																						CARRY_OUT => level1(2)(i+1));
													end generate level2to1_53_cond_first;
					level2to1_53_cond_mid: if i=11 or i=12 generate
												level2to1_53: compressor_53 PORT MAP (	A => level2(5)(i),
																						B => level2(4)(i),
																						C => level2(3)(i),
																						D => level2(2)(i),
																						CARRY_IN => level2(1)(i),
																						SUM0 => level1(1)(i),
																						SUM1 => level1(0)(i+1),
																						CARRY_OUT => level1(2)(i+1));
													end generate level2to1_53_cond_mid;
					level2to1_53_cond_last: if i=13 generate
												level2to1_53: compressor_53 PORT MAP (	A => '0',
																						B => level2(5)(i),
																						C => level2(4)(i),
																						D => level2(3)(i),
																						CARRY_IN => level2(2)(i),
																						SUM0 => level1(1)(i),
																						SUM1 => level1(0)(i+1),
																						CARRY_OUT => level1(2)(i+1));
													end generate level2to1_53_cond_last;
					level2to1_fa_cond: if i=14 generate
												level2to1_ha: fulladd PORT MAP (	x => level2(4)(i),
																					y => level2(3)(i),
																					Cin => level2(2)(i),
																					s => level1(1)(i),
																					Cout => level1(0)(i+1));
													end generate level2to1_fa_cond;
					level2to1_ha_cond_last: if i=15 generate
												level2to1_ha: halfadd PORT MAP (	A => level2(4)(i),
																					B => level2(3)(i),
																					SUM => level1(1)(i),
																					CARRY => level1(0)(i+1));
													end generate level2to1_ha_cond_last;
					end generate level2to1;	
	

------------------------------------------------------------------------------------------------
--passing through bits level1 to level0

	
--additive 0s for next layer
	level0(0)(6) <= '0';

--from level1 to level0 compression layer
	level1to0: for i in 6 to 17 generate
					level1to0_42approx_cond: if i>=6 and i<=8 generate
										level1to0_42approx: compressor_42_approx PORT MAP (	A => level1(3)(i),
																								B => level1(2)(i),
																								C => level1(1)(i),
																								D => level1(0)(i),
																								SUM0 => level0(1)(i),
																								SUM1 => level0(0)(i+1));
													end generate level1to0_42approx_cond;
					level1to0_42_cond: if i>=9 and i<=16 generate
										level1to0_fa: fulladd PORT MAP (	x => level1(2)(i),
																					y => level1(1)(i),
																					Cin => level1(0)(i),
																					s => level0(1)(i),
																					Cout => level0(0)(i+1));
													end generate level1to0_42_cond;										
					level1to0_ha_cond_last: if i=17 generate
														level1to0_ha: halfadd PORT MAP (	A => level1(1)(i),
																							B => level1(0)(i),
																							SUM => level0(1)(i),
																							CARRY => level0(0)(i+1));
													end generate level1to0_ha_cond_last;		
					end generate level1to0;			
--level0 to output
	out0(17 DOWNTO 6) <= level0(0)(17 DOWNTO 6); --operand 1
	out1(17 DOWNTO 6) <= level0(1)(17 DOWNTO 6); --operand 2
	out0(5 DOWNTO 0) <= (others=>'0');
	out1(5 DOWNTO 0) <= (others=>'0');
	
END final_cut;