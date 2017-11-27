LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.math_real.all;

ENTITY tb_MBE IS
	GENERIC(Nb: INTEGER := 9;
			shift: INTEGER := 2
	);
END ENTITY;

ARCHITECTURE test OF tb_MBE IS
	TYPE part_prod IS ARRAY(NATURAL(FLOOR(REAL((Nb+1)/2)))-1 DOWNTO 0) OF STD_LOGIC_VECTOR(2*Nb-1 DOWNTO 0);
	
	SIGNAL ck, resetn: STD_LOGIC;
	SIGNAL A_unsigned, B_unsigned: UNSIGNED(Nb-1 DOWNTO 0);
	SIGNAL A_tb, B_tb: STD_LOGIC_VECTOR(Nb-1 DOWNTO 0);
	SIGNAL PP_out: STD_LOGIC_VECTOR((2*Nb)*NATURAL(FLOOR(REAL((Nb+1)/2)))-1 DOWNTO 0);
	
	SIGNAL rand_num_A, rand_num_B: INTEGER := 0;
	
	SIGNAL PP_array: part_prod;
	
	COMPONENT MBE IS
	GENERIC(	Nb: INTEGER := 9;
				shift: INTEGER :=2
	);
	PORT(	A: IN STD_LOGIC_VECTOR(Nb-1 DOWNTO 0);
			B: IN STD_LOGIC_VECTOR(Nb-1 DOWNTO 0);
			PP_out: OUT STD_LOGIC_VECTOR((2*Nb)*NATURAL(FLOOR(REAL((Nb+1)/2)))-1 DOWNTO 0)  --instantiate number of outputs according to the number of triplets
	);
	END COMPONENT;
	
BEGIN
	
	UUT: MBE 	GENERIC MAP(Nb => Nb, shift => shift)
				PORT MAP(A => A_tb, B => B_tb, PP_out => PP_out);
				
	reset_PROCESS: PROCESS
	BEGIN
		resetn <= '0';
		WAIT FOR 25 ns;
		resetn <= '1';
		WAIT;
	END PROCESS;
	
	clock_PROCESS: PROCESS
	BEGIN
		ck <= '0';
		WAIT FOR 10 ns;
		ck <= '1';
		WAIT FOR 10 ns;
	END PROCESS;
	
	test_PROCESS: PROCESS(ck)
		VARIABLE seed1, seed2, seed3, seed4: POSITIVE;    -- seed values for random generator
        VARIABLE randA, randB: REAL;    -- random real-number value in range 0 to 1.0
        VARIABLE range_of_randA : REAL := 65536.0;    -- 
		VARIABLE range_of_randB : REAL := -74086.0;    --
	BEGIN
		IF ck'event AND ck='1' THEN
			IF resetn='0' THEN
				rand_num_A <= 0;
				rand_num_B <= 0;
			ELSE
				uniform(seed1, seed2, randA);    -- generate random number between 0.0 and 1.0
				rand_num_A <= INTEGER(randA*range_of_randA);    -- rescale and convert integer part
				A_unsigned <= TO_UNSIGNED(rand_num_A, A_unsigned'LENGTH);
				A_tb <= STD_LOGIC_VECTOR(A_unsigned);
				uniform(seed3, seed4, randB);    -- generate random number between 0.0 and 1.0
				rand_num_B <= INTEGER(randB*range_of_randB);    -- rescale and convert integer part
				B_unsigned <= TO_UNSIGNED(rand_num_B, B_unsigned'LENGTH);
				B_tb <= STD_LOGIC_VECTOR(B_unsigned);
			END IF;
		END IF;	
	END PROCESS;
	
	Partial_product: FOR i IN 1 TO NATURAL(FLOOR(REAL((Nb+1)/2))) GENERATE
		PP_array(i-1) <= PP_out(i*(2*Nb)-1 DOWNTO (i-1)*(2*Nb));
	END GENERATE;
END test;