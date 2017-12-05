Library IEEE;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
USE ieee.math_real.all;

Entity MBE_dadda_mult_9x9 is
	Port(	A: IN STD_LOGIC_VECTOR(8 DOWNTO 0);
			B: IN STD_LOGIC_VECTOR(8 DOWNTO 0);
			m_out: OUT std_logic_vector (17 DOWNTO 0)
	);
End Entity;

ARCHITECTURE structural of MBE_dadda_mult_9x9 is
	
	type level2_type is array (4 DOWNTO 0) of std_logic_vector(17 DOWNTO 0);
	type level0_type is array (1 DOWNTO 0) of std_logic_vector(18 DOWNTO 0);
	
	Signal MBEtoSplit: STD_LOGIC_VECTOR (89 DOWNTO 0);
	Signal splitToDadda: level2_type;
	Signal daddaToSum: level0_type;
	Signal outLong: integer;
	
	Component dadda_tree_18x5_ext is
	Port(
		in0: IN std_logic_vector (17 DOWNTO 0);
		in1: IN std_logic_vector (17 DOWNTO 0);
		in2: IN std_logic_vector (17 DOWNTO 0);
		in3: IN std_logic_vector (17 DOWNTO 0);
		in4: IN std_logic_vector (17 DOWNTO 0);
		out0: OUT std_logic_vector (18 DOWNTO 0);
		out1: OUT std_logic_vector (18 DOWNTO 0)
	);
	End component;

	Component MBE IS
		GENERIC(	Nb: INTEGER := 9;
					shift: INTEGER :=2
		);
		PORT(	A: IN STD_LOGIC_VECTOR(Nb-1 DOWNTO 0);
				B: IN STD_LOGIC_VECTOR(Nb-1 DOWNTO 0);
				PP_out: OUT STD_LOGIC_VECTOR((2*Nb)*NATURAL(FLOOR(REAL((Nb+1)/2)))-1 DOWNTO 0)  --instantiate number of outputs according to the number of triplets
		);
	END Component;
	
BEGIN

	MBE_unit: MBE PORT MAP (A => A,
									B => B,
									PP_out => MBEToSplit); 
	
	Splitting: for i in 0 to 4 generate
						splitToDadda(i) <= MBEToSplit((18*(i+1))-1 downto (18*i));
					end generate Splitting;
					
	dadda_tree: dadda_tree_18x5_ext PORT MAP(in0 => splitToDadda(0),
															in1 => splitToDadda(1),
															in2 => splitToDadda(2),
															in3 => splitToDadda(3),
															in4 => splitToDadda(4),
															out0 => daddaToSum(0),
															out1 => daddaToSum(1));
	outLong <= to_integer(signed(daddaToSum(0))) + to_integer(signed(daddaToSum(1)));
	m_out <= std_logic_vector(to_signed(outLong,m_out'LENGTH));

END structural;



ARCHITECTURE NoExt of MBE_dadda_mult_9x9 is
	
	type level2_type is array (5 DOWNTO 0) of std_logic_vector(17 DOWNTO 0);
	type level0_type is array (1 DOWNTO 0) of std_logic_vector(17 DOWNTO 0);
	
	Signal MBEtoSplit: STD_LOGIC_VECTOR (107 DOWNTO 0);
	Signal splitToDadda: level2_type;
	Signal daddaToSum: level0_type;
	Signal outLong: integer;
	
	Component dadda_tree_18x6_NoExt is
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
	End component;

	Component MBE_Roorda IS
		GENERIC(	Nb: INTEGER := 9;
					shift: INTEGER :=2
		);
		PORT(	A: IN STD_LOGIC_VECTOR(Nb-1 DOWNTO 0);
				B: IN STD_LOGIC_VECTOR(Nb-1 DOWNTO 0);
				PP_out: OUT STD_LOGIC_VECTOR((2*Nb)*((Nb+3)/2)-1 DOWNTO 0)  --instantiate number of outputs according to the number of triplets
		);
	END Component;
	
BEGIN

	MBE_unit: MBE_Roorda PORT MAP (A => A,
							B => B,
							PP_out => MBEToSplit); 

	
	Splitting: for i in 0 to 5 generate
						splitToDadda(i) <= MBEToSplit((18*(i+1))-1 downto (18*i));
					end generate Splitting;
					
	dadda_tree: dadda_tree_18x6_NoExt PORT MAP(in0 => splitToDadda(0),
															in1 => splitToDadda(1),
															in2 => splitToDadda(2),
															in3 => splitToDadda(3),
															in4 => splitToDadda(4),
															in5 => splitToDadda(5),
															out0 => daddaToSum(0),
															out1 => daddaToSum(1));
	outLong <= to_integer(signed(daddaToSum(0))) + to_integer(signed(daddaToSum(1)));
	m_out <= std_logic_vector(to_signed(outLong,m_out'LENGTH));

END NoExt;